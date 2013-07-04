-- PROMPT Create the Package MAI
CREATE OR REPLACE PACKAGE mai AS
--
--   MAINTENANCE MANAGER application generic utilities
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/utl/mai.pck-arc   2.1   Jul 04 2013 10:30:12   James.Wadsworth  $
--       Module Name      : $Workfile:   mai.pck  $
--       Date into PVCS   : $Date:   Jul 04 2013 10:30:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 10:24:38  $
--       Version          : $Revision:   2.1  $
--
-----------------------------------------------------------------------------
--    Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
  -- package global variable definitions (PUBLIC)
  /* SCCS ID keyword, do not remove */
  g_sccsid	CONSTANT	VARCHAR2(2000) := '@(#)mai.pck	1.21 08/22/00';
  g_application_owner		VARCHAR2(30);
  g_language			VARCHAR2(30);
  /* some common error messages - prevent more than one database lookup */
  g_thing_already_exists	VARCHAR2(2000);
  g_thing_does_not_exist	VARCHAR2(2000);
  g_product                     VARCHAR2(6);
  --

  -----------------------------------------------------------------------------
  -- Function to Create BOQ Items
  --
  FUNCTION cre_boq_items
        ( p_defect_id          in	boq_items.boq_defect_id%TYPE
         ,p_rep_action_cat     in	boq_items.boq_rep_action_cat%TYPE
         ,p_oun_org_id         in	hig_admin_units.hau_admin_unit%TYPE
         ,p_treat_code         in	treatments.tre_treat_code%TYPE
         ,p_defect_code        in	defects.def_defect_code%TYPE
         ,p_sys_flag           in	road_segments_all.rse_sys_flag%TYPE
         ,p_atv_acty_area_code in	activities.atv_acty_area_code%TYPE
         ,p_tremodlev          in	number
         ,p_attr_value         in	number
        ) return number;

-------------------------------------------------------------------------------
-- Parse an inventory condition for cyclic maintenance inventory rules.

  function PARSE_INV_CONDITION 
	(instring            varchar2) 
	 return varchar2 ;

  procedure CALCULATE_INV_QUANTITY
        (he_id        in     road_segments_all.rse_he_id%type ,
         calc_type    in     standard_items.sta_calc_type%type,
         item_code    in     schedule_items.schi_sta_item_code%type,
         quantity     in out schedule_items.schi_calc_quantity%type);

  procedure rep_date_due ( 
           p_date               in date
          ,p_atv_acty_area_code in defect_priorities.dpr_atv_acty_area_code%type
          ,p_dpr_priority       in defect_priorities.dpr_priority%type
          ,p_dpr_action_cat     in defect_priorities.dpr_action_cat%type
          ,p_heid               in road_segments_all.rse_he_id%type 
          ,p_out_date           out date 
          ,p_error              out number);

-------------------------------------------------------------------------------
-- Parse an inventory condition for cyclic maintenance inventory rules.
--
    Function View_Exists( inv_view_name in inv_item_types.ity_view_name%type )
    return boolean;
    --
    Function View_In_Use(view_name in inv_item_types.ity_view_name%type)
    return boolean;
    --
    Function Synonym_Exists(synonym in inv_item_types.ity_view_name%type)
    return boolean;
    --
    Procedure Create_view (view_name     in inv_item_types.ity_view_name%type
                          ,inventory_type in inv_item_types.ity_inv_code%type
                          ,sys_flag       in inv_item_types.ity_sys_flag%type);
    -- 
    Procedure Create_inv_view(view_name   in inv_item_types.ity_view_name%type
                             ,inventory_type in inv_item_types.ity_inv_code%type
                             ,sys_flag    in inv_item_types.ity_sys_flag%type);
    --
    
-------------------------------------------------------------------------------
--
-- Start off functions and procedures used in mai3899, the manual inspection
-- entry screen
--
  function activities_report_id( p_rse_he_id		in road_segs.rse_he_id%type
					  ,p_maint_insp_flag	in activities_report.are_maint_insp_flag%type
					  ,p_date_work_done	in activities_report.are_date_work_done%type
					  ,p_initiation_type	in activities_report.are_initiation_type%type
					  ,p_person_id_actioned	in activities_report.are_peo_person_id_actioned%type
					  ,p_person_id_insp2	in activities_report.are_peo_person_id_insp2%type
					  ,p_surface		in activities_report.are_surface_condition%type
					  ,p_weather		in activities_report.are_weather_condition%type
					  ,p_acty_area_code	in activities.atv_acty_area_code%type
				 	  ,p_start_chain		in activities_report.are_st_chain%type
					  ,p_end_chain		in activities_report.are_end_chain%type
) return number;

  procedure delete_activities_report(p_report_id in activities_report.are_report_id%type);

  procedure delete_are_defects(p_report_id in activities_report.are_report_id%type);

-------------------------------------------------------------------------------
  function create_defect (
		p_rse_he_id				in	defects.def_rse_he_id%type
		,p_iit_item_id			in	defects.def_iit_item_id%type
		,p_st_chain				in	defects.def_st_chain%type
		,p_report_id			in	defects.def_are_report_id%type
		,p_acty_area_code			in	defects.def_atv_acty_area_code%type
		,p_siss_id				in	defects.def_siss_id%type
		,p_works_order_no			in	defects.def_works_order_no%type
		,p_defect_code			in	defects.def_defect_code%type
		,p_orig_priority			in	defects.def_orig_priority%type
		,p_priority				in	defects.def_priority%type
		,p_status_code			in	defects.def_status_code%type
		,p_area				in	defects.def_area%type
		,p_are_id_not_found		in	defects.def_are_id_not_found%type
		,p_coord_flag			in	defects.def_coord_flag%type
		,p_defect_class			in	defects.def_defect_class%type
		,p_defect_descr			in	defects.def_defect_descr%type
		,p_defect_type_descr		in	defects.def_defect_type_descr%type
		,p_diagram_no			in	defects.def_diagram_no%type
		,p_height				in	defects.def_height%type
		,p_ident_code			in	defects.def_ident_code%type
		,p_ity_inv_code			in	defects.def_ity_inv_code%type
		,p_ity_sys_flag			in	defects.def_ity_sys_flag%type
		,p_length				in	defects.def_length%type
		,p_locn_descr			in	defects.def_locn_descr%type
		,p_maint_wo				in	defects.def_maint_wo%type
		,p_mand_adv				in	defects.def_mand_adv%type
		,p_notify_org_id			in	defects.def_notify_org_id%type
		,p_number				in	defects.def_number%type
		,p_per_cent				in	defects.def_per_cent%type
		,p_per_cent_orig			in	defects.def_per_cent_orig%type
		,p_per_cent_rem			in	defects.def_per_cent_rem%type
		,p_rechar_org_id			in	defects.def_rechar_org_id%type
		,p_serial_no			in	defects.def_serial_no%type
		,p_skid_coeff			in	defects.def_skid_coeff%type
		,p_special_instr			in	defects.def_special_instr%type
		,p_time_hrs				in	defects.def_time_hrs%type
		,p_time_mins			in	defects.def_time_mins%type
		,p_update_inv			in	defects.def_update_inv%type
		,p_x_sect				in	defects.def_x_sect%type
            ,p_easting				in	defects.def_easting%type
		,p_northing				in	defects.def_northing%type
		,p_response_category		in	defects.def_response_category%type
) return number;
--
-----------------------------------------------------------------------------------
--
function create_repair (
		p_defect_id				in	repairs.rep_def_defect_id%type
		,p_action_cat			in	repairs.rep_action_cat%type
		,p_rse_he_id			in	repairs.rep_rse_he_id%type
		,p_treat_code			in	repairs.rep_tre_treat_code%type
		,p_acty_area_code			in	repairs.rep_atv_acty_area_code%type
		,p_date_due				in	repairs.rep_date_due%type
		,p_descr				in	repairs.rep_descr%type
		,p_local_date_due			in	repairs.rep_local_date_due%type
		,p_old_due_date			in	repairs.rep_old_due_date%type
) return number;

-----------------------------------------------------------------------------------

function create_doc_assocs (
		p_table_name			in	doc_assocs.das_table_name%type
		,p_rec_id    			in	doc_assocs.das_rec_id%type
		,p_doc_id   			in	doc_assocs.das_doc_id%type
) return number;

-----------------------------------------------------------------------------------

function delete_doc_assocs (
		p_table_name			in	doc_assocs.das_table_name%type
		,p_rec_id    			in	doc_assocs.das_rec_id%type
		,p_doc_id   			in	doc_assocs.das_doc_id%type
) return number;
--
Function Get_hco_seq ( domain_value in hig_codes.hco_domain%type
                      ,code_value   in hig_codes.hco_code%type)
return number;                                                                
-----------------------------------------------------------------------------------

function get_version return varchar2;	-- return sccs version number
--

pragma restrict_references( Get_hco_seq, wnds); 
pragma restrict_references( Get_version, wnds);
--
END mai;
/


PROMPT Create the Package Body MAI
CREATE OR REPLACE PACKAGE BODY mai AS

-------------------------------------------------------------------------------
-- Return the SCCS id of the package


function get_version return varchar2 is
begin
    return g_sccsid;
end;
  
-------------------------------------------------------------------------------
-- Parse an inventory condition for cyclic maintenance inventory rules.
 

function PARSE_INV_CONDITION 
	(instring            varchar2) 
	 return varchar2 is

  dummycursor		integer;
begin

  dummycursor	:= dbms_sql.open_cursor;
  dbms_sql.parse(dummycursor,
                'select null from inv_items_all where '||instring,
                dbms_sql.native);

  return('PARSED');

exception 
  when others then return('NOT PARSED'); 
end;

  -----------------------------------------------------------------------------
   -- Function to Create BOQ Items
   --
   FUNCTION cre_boq_items( 
        p_defect_id          in		boq_items.boq_defect_id%TYPE
       ,p_rep_action_cat     in		boq_items.boq_rep_action_cat%TYPE
       ,p_oun_org_id         in		hig_admin_units.hau_admin_unit%TYPE
       ,p_treat_code         in		treatments.tre_treat_code%TYPE
       ,p_defect_code        in		defects.def_defect_code%TYPE
       ,p_sys_flag           in	        road_segments_all.rse_sys_flag%TYPE
       ,p_atv_acty_area_code in		activities.atv_acty_area_code%TYPE
       ,p_tremodlev          in		number
       ,p_attr_value         in		number )
   return number IS

l_return    number;

begin

insert into boq_items
(      boq_work_flag
      ,boq_defect_id
      ,boq_rep_action_cat
      ,boq_wol_id
      ,boq_sta_item_code
      ,boq_date_created
      ,boq_est_dim1
      ,boq_est_dim2
      ,boq_est_dim3
      ,boq_est_quantity
      ,boq_est_rate
      ,boq_est_cost
      ,boq_est_labour)
select 'D'
      ,p_defect_id
      ,p_rep_action_cat
      ,0
      ,sta.sta_item_code
      ,sysdate
      ,nvl(tmi.tmi_default_quantity,
           tmi.tmi_multiplier * nvl(p_attr_value,0) )
      ,decode( sta_dim2_text, null, null, 1 )
      ,decode( sta_dim3_text, null, null, 1 )
      ,nvl(tmi.tmi_default_quantity,
           tmi.tmi_multiplier * nvl(p_attr_value,0) )
      ,sta.sta_rate 
      ,sta.sta_rate * nvl(tmi.tmi_default_quantity,
           tmi.tmi_multiplier * nvl(p_attr_value,0) )
      ,nvl(tmi.tmi_default_quantity,
           tmi.tmi_multiplier * nvl(p_attr_value,0) ) * sta_labour_units
from standard_items         sta
    ,treatment_model_items  tmi
    ,treatment_models       tmo
    ,def_types              dty
    ,hig_admin_units        hau
    ,hig_admin_groups       hag
where hau.hau_level              = p_tremodlev
and   hau.hau_admin_unit         = hag.hag_parent_admin_unit
and   tmo.tmo_oun_org_id         = hau.hau_admin_unit
and   hag.hag_child_admin_unit   = p_oun_org_id
and   tmo.tmo_tre_treat_code     = p_treat_code
and   tmo.tmo_atv_acty_area_code = p_atv_acty_area_code
and   tmo.tmo_dty_defect_code    = p_defect_code
and   tmo.tmo_sys_flag           = p_sys_flag
and   dty.dty_defect_code        = p_defect_code
and   dty.dty_atv_acty_area_code = p_atv_acty_area_code
and   dty.dty_dtp_flag           = p_sys_flag
and   tmi.tmi_tmo_id             = tmo.tmo_id
and   tmi.tmi_sta_item_code      = sta.sta_item_code;

return( sql%rowcount );

exception
   when no_data_found then
      return (0);
   when others then
      return (-1);
end;

procedure CALCULATE_INV_QUANTITY
        (he_id        in     road_segments_all.rse_he_id%type ,
         calc_type    in     standard_items.sta_calc_type%type,
         item_code    in     schedule_items.schi_sta_item_code%type,
         quantity     in out schedule_items.schi_calc_quantity%type) is
      cursor c1 is
      select
         'select nvl('||'sum( nvl('||
         'decode ('|| '''' || calc_type || '''' ||','
         ||
         ''''|| 'L'|| ''''
         ||
         ',nvl(i1.iit_end_chain,i1.iit_st_chain)-i1.iit_st_chain,'
         ||
         ''''|| 'A'|| ''''
         ||
         ',nvl(i1.iit_width,0) * nvl(i1.iit_height,0),'
         ||
         ''''|| 'N'|| ''''||',1,' 
         || 
         ''''|| 'T'||''''
         ||
       ',(nvl(i1.iit_width,0)+ decode(nvl(i2.iit_width,0),0,nvl(i1.iit_width,0)
             ,i2.iit_width) )*0.5* (i1.iit_end_chain - i1.iit_st_chain)),0 ) * '
         ||'r1.rel_factor'||
         '),0 ) from inv_items_all i1, inv_items_all i2, road_segments_all,
             related_inventory r1 where rse_he_id = ' 
         || to_char(he_id) 
         || 
         ' and i1.iit_ity_inv_code     = r1.rel_ity_inv_code
	   and i1.iit_ity_sys_flag     = r1.rel_ity_sys_flag
                and i1.iit_rse_he_id        = ' 
         || to_char(he_id) 
         ||
         ' and r1.rel_sta_item_code    = '
         ||
         ''''|| item_code || '''' 
         ||
         ' and ' || '''' || sysdate || '''' || 
               ' between i1.iit_cre_date and nvl(i1.iit_end_date, sysdate) ' 
         ||
         ' and ' || '''' || sysdate || '''' || 
               ' between rse_start_date and nvl(rse_end_date,sysdate) '
         ||
         ' and ' || '''' || sysdate || '''' || 
               ' between i2.iit_cre_date(+) and  nvl(i2.iit_end_date(+), sysdate) '
         ||
         ' and i1.iit_ity_sys_flag     = rse_sys_flag
               and i2.iit_rse_he_id(+)     = ' 
         || to_char(he_id) 
         ||
         ' and i2.iit_ity_inv_code (+) = i1.iit_ity_inv_code
	   and i2.iit_ity_sys_flag (+) = i1.iit_ity_sys_flag
               and i2.iit_st_chain (+)     = i1.iit_end_chain
               and nvl(i2.iit_x_sect(+),'
         ||
         ''''||'Z'||''''
         ||
         ') = nvl(i1.iit_x_sect,'
         ||
         ''''||'Z'||''''||')'||
       ' and '||decode(r2.rel_condition, null, '1=1', 'i1.'||r2.rel_condition)||
       ' and '||decode(r2.rel_condition, null, '1=1', 'i2.'||r2.rel_condition)
         from related_inventory r2
         where r2.rel_sta_item_code = item_code;

      l_query varchar2(32767);
      l_cursor_id integer;
      l_status integer;
      lcnt number;
     
      begin
      open c1;
      fetch c1 into l_query;
      close c1;
      higgri.parse_query(l_query,l_cursor_id);   -- parse the query
      dbms_sql.define_column(l_cursor_id,1,lcnt);   -- define col to return
      l_status := dbms_sql.execute(l_cursor_id);    -- execute query
      loop
        if dbms_sql.fetch_rows(l_cursor_id) > 0 then  -- fetch back from cursor
          dbms_sql.column_value(l_cursor_id,1,lcnt);    -- assign to variable
        else
          exit;
        end if;
      end loop;
      dbms_sql.close_cursor(l_cursor_id);           -- close cursor
      quantity := lcnt;           -- pass calculated value back
      end;

 
procedure rep_date_due ( 
           p_date               in date
          ,p_atv_acty_area_code in defect_priorities.dpr_atv_acty_area_code%type
          ,p_dpr_priority       in defect_priorities.dpr_priority%type
          ,p_dpr_action_cat     in defect_priorities.dpr_action_cat%type
          ,p_heid               in road_segments_all.rse_he_id%type 
          ,p_out_date           out date 
          ,p_error              out number) is

 cursor c_int_code is                                                           
    select dpr_int_code                                                         
          ,dpr_use_working_days                                                 
          ,dpr_use_next_insp
    from   defect_priorities                                                    
    where  dpr_atv_acty_area_code = p_atv_acty_area_code                        
    and    dpr_priority           = p_dpr_priority                              
    and    dpr_action_cat         = p_dpr_action_cat;                           
 --                                                                             
 cursor get_rse_int_code is
    select  rse.rse_int_code
    from    road_segments_all rse
           ,intervals         int
    where   rse.rse_int_code      = int.int_code
    and     rse.rse_he_id         = p_heid
    and     p_date
    between nvl(int.int_start_date,p_date)
    and     nvl(int.int_end_date,p_date);
 --
    l_int_code               defect_priorities.dpr_int_code%type;              
    l_use_working_days       defect_priorities.dpr_use_working_days%type;      
    l_use_next_insp          defect_priorities.dpr_use_next_insp%type;
 --                                                                             
    v_error    number:=0;
 --                                                                             
 begin                                                                          
    l_use_working_days:='N'; -- Initialize Use Working Days
    l_use_next_insp:='N';    -- Initialize Use Next Inspection
 --
    open  c_int_code;                                                           
    fetch c_int_code into l_int_code                                            
                         ,l_use_working_days
                         ,l_use_next_insp;
--
    if  c_int_code%notfound 
    then v_error:=8509;
    end if;                                                                     
 --                                                                             
    close c_int_code;                                                           
 --                                                                             
 -- The inspection interval can be obtained from the defect_prriorities
 -- table OR form the road_segs table for the specified sectioin.
 -- The flag dpr_use_next_insp should be obtained from the defect_
 -- priorities table and if the flag is 'Y' then the interval code to
 -- be used should be obtained from the road_segs table otherwise the
 -- default interval code from the defect_priorities table should be
 -- used.
 --
    if v_error = 0 then
    if l_use_next_insp = 'Y' 
    then -- obtain the interval code from the road_segs table for the
         -- selected section.
         -- the intervals table is used in the query so that a check
         -- for existance is made against the interval code since
         -- the interval code may be null.
         open get_rse_int_code;
         fetch get_rse_int_code into l_int_code;
         if get_rse_int_code%notfound
         then v_error:=8213;             -- Unable to obtain interval code 
         end if;
         close get_rse_int_code;
    end if;
 --   
    if l_use_working_days = 'Y' 
    then p_out_date:=hig.date_due(p_date,l_int_code,true);          
    else p_out_date:=hig.date_due(p_date,l_int_code,false);       
    end if;                                                                     
	p_error := v_error;
  else

-- Invalid interval - no need to try and find date due.

	p_error := v_error;
  end if;
end;

----------------------------------------------------------------------------
-- Start of functions and procedures required for inventory view creattion
-- via mai1400
--
Function View_Exists ( inv_view_name in inv_item_types.ity_view_name%type )
return boolean
is 
      cursor user_view_exists
      is select 1
         from    all_objects
         where   object_name = inv_view_name
         and     object_type = 'VIEW'
         and     status      = 'VALID';
--
v_exists integer;         
--
begin
     open user_view_exists;
     fetch user_view_exists into v_exists;
     if user_view_exists%found
     then   close user_view_exists;
            return true;
     else   close user_view_exists;            
            return false;
     end if;
end View_Exists;
--   
-- Check if the existing view is in use within the database.
--
Function view_in_use ( view_name in inv_item_types.ity_view_name%type )
return boolean
is
   exclusive_mode integer:=6;
   id             integer:=100;
   --
   cursor in_use -- Dummy cursor for the present.
   is select 1
      from dual;
   --
   v_in_use integer;
   --
begin
     open in_use;
     fetch in_use into v_in_use;
     if in_use%found
     then close in_use;
            return false; -- Reversed logic so that function
     else close in_use;   -- does not fail.
            return true;
     end if;
end View_In_Use; 
--  
--  
-- When called, this procedure should perform the actual creation of the 
-- specified inventory view. A return code should be provided if there were any -- problems when creating the view object. ( Such as insufficient privelages ).
--
Function Synonym_exists( synonym in inv_item_types.ity_view_name%type )
return boolean
is
    cursor syn_exists
    is select 1
       from   all_synonyms
       where  synonym_name= synonym
       and    owner       = 'PUBLIC';
--
v_exists integer;
--
begin
    open  syn_exists;
    fetch syn_exists into v_exists;
    if syn_exists%found
    then  close syn_exists;
          return true;
    else  close syn_exists;
          return false;
    end if;
end Synonym_Exists;
--   
Procedure Create_view ( view_name      in inv_item_types.ity_view_name%type
                       ,inventory_type in inv_item_types.ity_inv_code%type
                       ,sys_flag       in inv_item_types.ity_sys_flag%type)is
       --
       v_stg          varchar2(2000); 
       s_stg          varchar2(2000); 
       v_query        integer; 
       exec_ok        integer; 
       l_p_or_c       inv_item_types.ity_pnt_or_cont%type;
       incl_road_segs inv_item_types.ity_incl_road_segs%type;
       --
       -- get type of inventory item so end-chain can be included/excluded
       --
       cursor get_p_or_c is
          select ity_pnt_or_cont,
                 ity_incl_road_segs
          from inv_item_types 
          where ity_inv_code = inventory_type
          and ity_sys_flag = sys_flag ;
       -- 
       -- Obtain all specified inventory columns for the selected inventory 
       -- type. 
       -- 
       cursor all_attributes 
       is select ita_attrib_name  
                    ,ita_view_col_name 
                    ,ita_dtp_code     
          from     inv_type_attribs 
          where    ita_iit_inv_code = inventory_type 
          and      ita_ity_sys_flag = sys_flag 
          order by ita_disp_seq_no; 
       --
   invalid_item_type exception;
begin 
      --
   dbms_output.enable (1000000); 
      --  

   open get_p_or_c;
   fetch get_p_or_c into l_p_or_c,incl_road_segs;
   if get_p_or_c%notfound then
      close get_p_or_c;
      raise invalid_item_type;
   else
      close get_p_or_c;
      if l_p_or_c = 'P' then
        
         v_stg:='Create or Replace view '||view_name|| 
             ' as select /* INDEX (INV_ITEMS_ALL IIT_INDEX_P2) */'||
             ' iit_created_date,iit_cre_date,iit_item_id '|| 
             ',iit_ity_inv_code,iit_ity_sys_flag,iit_last_updated_date'|| 
             ',iit_rse_he_id,iit_st_chain,iit_x_sect,iit_end_date'; 
          -- 
       else
         v_stg:='Create or Replace view '||view_name|| 
             ' as select /* INDEX (INV_ITEMS_ALL IIT_INDEX_P2) */'||
             ' iit_created_date,iit_cre_date,iit_item_id '|| 
             ',iit_ity_inv_code,iit_ity_sys_flag,iit_last_updated_date'|| 
             ',iit_rse_he_id,iit_st_chain,iit_end_chain,iit_x_sect,iit_end_date'; 
       end if;
       --
       
--
          for each_attribute in all_attributes 
          loop 
              v_stg:=v_stg||','||each_attribute.ita_attrib_name||' '||each_attribute.ita_view_col_name; 
          end loop; 
          -- 
          IF incl_road_segs = 'Y' THEN
            v_stg := v_stg||',RSE_LENGTH_STATUS SEC_LEN_STAT, RSE_UNIQUE, RSE_DESCR, RSE_LENGTH, RSE_ROAD_ENVIRONMENT, RSE_END_DATE, RSE_ADMIN_UNIT '
                          ||' from inv_items_all, road_sections_all where iit_rse_he_id = rse_he_id and iit_ity_inv_code='||'''' 
                          ||inventory_type||''''||' and 
                          iit_ity_sys_flag='||''''||sys_flag||'''';
          ELSE
            v_stg:=v_stg||' from inv_items_all where iit_ity_inv_code='||'''' 
                        ||inventory_type||''''||' and 
                          iit_ity_sys_flag='||''''||sys_flag||''''; 
          END IF;
          --
          v_query:=dbms_sql.open_cursor; 
          dbms_sql.parse(v_query,v_stg,dbms_sql.v7); 
          exec_ok:=dbms_sql.execute(v_query); 
          dbms_sql.close_cursor(v_query); 
          --
          if hig.get_sysopt('HIGPUBSYN') = 'Y'
          then   -- 
               if synonym_exists(view_name)
               then s_stg:='drop public synonym '||view_name;
                    --
                    v_query:=dbms_sql.open_cursor; 
                    dbms_sql.parse(v_query,s_stg,dbms_sql.v7); 
                    exec_ok:=dbms_sql.execute(v_query); 
                    dbms_sql.close_cursor(v_query); 
                    --
               end if;
               --
               -- Create the public synonym for the previouslry created view. 
               -- 
               s_stg:='create public synonym '|| 
                       view_name|| 
                      ' for '||user||'.'||view_name; 
               --
               v_query:=dbms_sql.open_cursor; 
               dbms_sql.parse(v_query,s_stg,dbms_sql.v7); 
               exec_ok:=dbms_sql.execute(v_query); 
               dbms_sql.close_cursor(v_query); 
               --
          end if;
  end if;
          --  
exception
  when invalid_item_type then
     raise_application_error( -20001, 'Invalid Item Type - View cannot be created');
end Create_View; 
--
Procedure Create_inv_view (  view_name     in inv_item_types.ity_view_name%type
                            ,inventory_type in inv_item_types.ity_inv_code%type
                            ,sys_flag       in inv_item_types.ity_sys_flag%type)
is
  Specified_View_In_Use exception;
  Pragma exception_init (Specified_View_In_Use,-20002);
Begin
    --    
    -- Logic : If the specified view doew NOT exist 
    --         then Create the specified view.
    --         else If the view is In-Use 
    --         then return and error indicating usage
    --         else Create the view.
    --
    if not view_exists(view_name)
    then   create_view(view_name,inventory_type,sys_flag);
    elsif  view_in_use(view_name)
    then   raise_application_error( -20002,'Specified_View_In_Use');
    else   create_view(view_name,inventory_type,sys_flag);
    end if;
  exception
  when others
  then 
     raise_application_error( -20002, sqlerrm );
end Create_inv_view;


-------------------------------------------------------------------------------
--
-- Start off functions and procedures used in mai3899, the manual inspection
-- entry screen
--

function activities_report_id( p_rse_he_id		in road_segs.rse_he_id%type
					,p_maint_insp_flag	in activities_report.are_maint_insp_flag%type
					,p_date_work_done		in activities_report.are_date_work_done%type
					,p_initiation_type	in activities_report.are_initiation_type%type
					,p_person_id_actioned	in activities_report.are_peo_person_id_actioned%type
					,p_person_id_insp2	in activities_report.are_peo_person_id_insp2%type
					,p_surface			in activities_report.are_surface_condition%type
					,p_weather			in activities_report.are_weather_condition%type
					,p_acty_area_code		in activities.atv_acty_area_code%type
					,p_start_chain		in activities_report.are_st_chain%type
					,p_end_chain		in activities_report.are_end_chain%type
) return number is

  l_report_id	activities_report.are_report_id%type;
  l_rse_length	road_segs.rse_length%type;
  l_today		date := sysdate;
  insert_error	exception;

  cursor c1 is
    select rse_length
    from   road_segs
    where  rse_he_id = p_rse_he_id;

begin

  select are_report_id_seq.nextval
  into   l_report_id
  from   dual;

  open c1;
  fetch c1 into l_rse_length;
  close c1;

  insert into ACTIVITIES_REPORT (
			 ARE_REPORT_ID
			,ARE_RSE_HE_ID
			,ARE_BATCH_Id
			,ARE_CREATED_DATE
			,ARE_LAST_UPDATED_DATE
			,ARE_MAINT_INSP_FLAG
			,ARE_SCHED_ACT_FLAG
			,ARE_DATE_WORK_DONE
			,ARE_END_CHAIN
			,ARE_INITIATION_TYPE
			,ARE_INSP_LOAD_DATE
			,ARE_PEO_PERSON_ID_ACTIONED
			,ARE_PEO_PERSON_ID_INSP2
			,ARE_ST_CHAIN
			,ARE_SURFACE_CONDITION
			,ARE_WEATHER_CONDITION
			,ARE_WOL_WORKS_ORDER_NO)
  values (
			 l_report_id
			,p_rse_he_id
			,''
			,l_today
			,l_today
			,p_maint_insp_flag
			,'Y'
			,p_date_work_done
			,nvl(p_end_chain,l_rse_length)
			,p_initiation_type
			,''
			,p_person_id_actioned
			,p_person_id_insp2
			,nvl(p_start_chain,0)
			,p_surface
			,p_weather
			,'');

  if sql%rowcount != 1 then
    raise insert_error;
  end if;

  insert into ACT_REPORT_LINES (
			 ARL_ACT_STATUS
			,ARL_ARE_REPORT_ID
			,ARL_ATV_ACTY_AREA_CODE
			,ARL_CREATED_DATE
			,ARL_LAST_UPDATED_DATE
			,ARL_NOT_SEQ_FLAG
			,ARL_REPORT_ID_PART_OF)
  values (
			 'C'
			,l_report_id
			,p_acty_area_code
			,l_today
			,l_today
			,''
			,'');

  if sql%rowcount != 1 then
    raise insert_error;
  end if;

  return l_report_id;

exception
  when insert_error then
    raise_application_error(-20001, 'Error occured while creating Activities Report');

end;


procedure delete_activities_report(p_report_id in activities_report.are_report_id%type) is
begin

  delete from act_report_lines
  where  arl_are_report_id = p_report_id;

  delete from activities_report
  where  are_report_id= p_report_id;

end;


procedure delete_are_defects(p_report_id in activities_report.are_report_id%type) is
begin

  delete from boq_items
  where  boq_defect_id in (select def_defect_id
				   from   defects
				   where  def_are_report_id = p_report_id);

  delete from repairs
  where  rep_def_defect_id in (select def_defect_id
					 from   defects
					 where  def_are_report_id = p_report_id);

  delete from defects
  where  def_are_report_id = p_report_id;

end;

-------------------------------------------------------------------------------

function create_defect( 
		p_rse_he_id				in	defects.def_rse_he_id%type
		,p_iit_item_id			in	defects.def_iit_item_id%type
		,p_st_chain				in	defects.def_st_chain%type
		,p_report_id			in	defects.def_are_report_id%type
		,p_acty_area_code			in	defects.def_atv_acty_area_code%type
		,p_siss_id				in	defects.def_siss_id%type
		,p_works_order_no			in	defects.def_works_order_no%type
		,p_defect_code			in	defects.def_defect_code%type
		,p_orig_priority			in	defects.def_orig_priority%type
		,p_priority				in	defects.def_priority%type
		,p_status_code			in	defects.def_status_code%type
		,p_area				in	defects.def_area%type
		,p_are_id_not_found		in	defects.def_are_id_not_found%type
		,p_coord_flag			in	defects.def_coord_flag%type
		,p_defect_class			in	defects.def_defect_class%type
		,p_defect_descr			in	defects.def_defect_descr%type
		,p_defect_type_descr		in	defects.def_defect_type_descr%type
		,p_diagram_no			in	defects.def_diagram_no%type
		,p_height				in	defects.def_height%type
		,p_ident_code			in	defects.def_ident_code%type
		,p_ity_inv_code			in	defects.def_ity_inv_code%type
		,p_ity_sys_flag			in	defects.def_ity_sys_flag%type
		,p_length				in	defects.def_length%type
		,p_locn_descr			in	defects.def_locn_descr%type
		,p_maint_wo				in	defects.def_maint_wo%type
		,p_mand_adv				in	defects.def_mand_adv%type
		,p_notify_org_id			in	defects.def_notify_org_id%type
		,p_number				in	defects.def_number%type
		,p_per_cent				in	defects.def_per_cent%type
		,p_per_cent_orig			in	defects.def_per_cent_orig%type
		,p_per_cent_rem			in	defects.def_per_cent_rem%type
		,p_rechar_org_id			in	defects.def_rechar_org_id%type
		,p_serial_no			in	defects.def_serial_no%type
		,p_skid_coeff			in	defects.def_skid_coeff%type
		,p_special_instr			in	defects.def_special_instr%type
		,p_time_hrs				in	defects.def_time_hrs%type
		,p_time_mins			in	defects.def_time_mins%type
		,p_update_inv			in	defects.def_update_inv%type
		,p_x_sect				in	defects.def_x_sect%type
            ,p_easting				in	defects.def_easting%type
		,p_northing				in	defects.def_northing%type
		,p_response_category		in	defects.def_response_category%type
) return number is

  l_defect_id	defects.def_defect_id%type;
  l_today		date := sysdate;
  insert_error	exception;

begin

  select def_defect_id_seq.nextval
  into   l_defect_id
  from   dual;

  insert into DEFECTS (
		DEF_DEFECT_ID                  
		,DEF_RSE_HE_ID        
	      ,DEF_IIT_ITEM_ID             ----- New          
		,DEF_ST_CHAIN                   
		,DEF_ARE_REPORT_ID              
		,DEF_ATV_ACTY_AREA_CODE         
		,DEF_SISS_ID                    
		,DEF_WORKS_ORDER_NO             
		,DEF_CREATED_DATE               
		,DEF_DEFECT_CODE                
		,DEF_LAST_UPDATED_DATE          
		,DEF_ORIG_PRIORITY              
		,DEF_PRIORITY                   
		,DEF_STATUS_CODE                
		,DEF_SUPERSEDED_FLAG            
		,DEF_AREA                       
		,DEF_ARE_ID_NOT_FOUND           
		,DEF_COORD_FLAG                 
		,DEF_DATE_COMPL                 
		,DEF_DATE_NOT_FOUND             
		,DEF_DEFECT_CLASS               
		,DEF_DEFECT_DESCR               
		,DEF_DEFECT_TYPE_DESCR          
		,DEF_DIAGRAM_NO                 
		,DEF_HEIGHT                     
		,DEF_IDENT_CODE                 
		,DEF_ITY_INV_CODE               
		,DEF_ITY_SYS_FLAG               
		,DEF_LENGTH                     
		,DEF_LOCN_DESCR                 
		,DEF_MAINT_WO                   
		,DEF_MAND_ADV                   
		,DEF_NOTIFY_ORG_ID              
		,DEF_NUMBER                     
		,DEF_PER_CENT                   
		,DEF_PER_CENT_ORIG              
		,DEF_PER_CENT_REM               
		,DEF_RECHAR_ORG_ID              
		,DEF_SERIAL_NO                  
		,DEF_SKID_COEFF                 
		,DEF_SPECIAL_INSTR              
		,DEF_SUPERSEDED_ID              
		,DEF_TIME_HRS                   
		,DEF_TIME_MINS                  
		,DEF_UPDATE_INV                 
		,DEF_X_SECT
            ,DEF_EASTING
            ,DEF_NORTHING
            ,DEF_RESPONSE_CATEGORY                    
		)
  values (
		l_defect_id
		,p_rse_he_id
		,p_iit_item_id
		,p_st_chain
		,p_report_id
		,p_acty_area_code
		,p_siss_id
		,p_works_order_no
		,l_today
		,p_defect_code
		,l_today
		,p_orig_priority
		,p_priority
		,p_status_code
		,'N'
		,p_area
		,p_are_id_not_found
		,p_coord_flag
		,''
		,''
		,p_defect_class
		,p_defect_descr
		,p_defect_type_descr
		,p_diagram_no
		,p_height
		,p_ident_code
		,p_ity_inv_code
		,p_ity_sys_flag
		,p_length
		,p_locn_descr
		,p_maint_wo
		,p_mand_adv
		,p_notify_org_id
		,p_number
		,p_per_cent
		,p_per_cent_orig
		,p_per_cent_rem
		,p_rechar_org_id
		,p_serial_no
		,p_skid_coeff
		,p_special_instr
		,''
		,p_time_hrs
		,p_time_mins
		,p_update_inv
		,p_x_sect
            ,p_easting
            ,p_northing
            ,p_response_category
		);

  if sql%rowcount != 1 then
    raise insert_error;
  end if;

  return l_defect_id;

exception
  when insert_error then
    raise_application_error(-20001, 'Error occured while creating Defect');

end;

----------------------------------------------------------------------------

function create_repair (
		p_defect_id				in	repairs.rep_def_defect_id%type
		,p_action_cat			in	repairs.rep_action_cat%type
		,p_rse_he_id			in	repairs.rep_rse_he_id%type
		,p_treat_code			in	repairs.rep_tre_treat_code%type
		,p_acty_area_code			in	repairs.rep_atv_acty_area_code%type
		,p_date_due				in	repairs.rep_date_due%type
		,p_descr				in	repairs.rep_descr%type
		,p_local_date_due			in	repairs.rep_local_date_due%type
		,p_old_due_date			in	repairs.rep_old_due_date%type
) return number is

  l_today		date := sysdate;
  insert_error	exception;

begin

 insert into REPAIRS (
		REP_DEF_DEFECT_ID              
		,REP_ACTION_CAT                 
		,REP_RSE_HE_ID                  
		,REP_TRE_TREAT_CODE             
		,REP_ATV_ACTY_AREA_CODE         
		,REP_CREATED_DATE               
		,REP_DATE_DUE                   
		,REP_LAST_UPDATED_DATE          
		,REP_SUPERSEDED_FLAG            
		,REP_COMPLETED_HRS              
		,REP_COMPLETED_MINS             
		,REP_DATE_COMPLETED             
		,REP_DESCR                      
		,REP_LOCAL_DATE_DUE             
		,REP_OLD_DUE_DATE               
		)
  values (
		p_defect_id	
		,p_action_cat
		,p_rse_he_id
		,p_treat_code
		,p_acty_area_code
		,l_today
		,p_date_due
		,l_today
		,'N'
		,''
		,''
		,''
		,p_descr
		,p_local_date_due
		,p_old_due_date
		);

  if sql%rowcount != 1 then
    raise insert_error;
  end if;

  return 0;

exception
  when insert_error then
    raise_application_error(-20001, 'Error occured while creating Repair');

end;

-------------------------------------------------------------------------------

function create_doc_assocs (
		p_table_name			in	doc_assocs.das_table_name%type
		,p_rec_id    			in	doc_assocs.das_rec_id%type
		,p_doc_id   			in	doc_assocs.das_doc_id%type
) return number is

  insert_error	exception;

begin

 insert into DOC_ASSOCS (
		DAS_TABLE_NAME                 
		,DAS_REC_ID                     
		,DAS_DOC_ID                     
		)
 values (
		p_table_name
		,p_rec_id    
		,p_doc_id    
		);

  if sql%rowcount != 1 then
    raise insert_error;
  end if;

  return 0;

exception
  when insert_error then
    raise_application_error(-20001, 'Error occured while creating Doc_Assocs');

end;

-------------------------------------------------------------------------------

function delete_doc_assocs (
		p_table_name			in	doc_assocs.das_table_name%type
		,p_rec_id    			in	doc_assocs.das_rec_id%type
		,p_doc_id   			in	doc_assocs.das_doc_id%type
) return number is

  delete_error	exception;

begin

 delete from DOC_ASSOCS
 where DAS_TABLE_NAME = p_table_name
   and DAS_REC_ID = p_rec_id
   and DAS_DOC_ID = p_doc_id;
		
 if sql%rowcount = 0 then
    raise delete_error;
 end if;

 return 0;

exception
  when delete_error then
    raise_application_error(-20001, 'Error occured while deleting Doc_Assocs');

end;

-------------------------------------------------------------------------------

function get_hco_seq ( domain_value in hig_codes.hco_domain%type
                      ,code_value   in hig_codes.hco_code%type )
return number is
tmpVar number;
--
  cursor get_code_seq
  is select hco_seq
     from   hig_codes
     where  hco_domain= domain_value
     and    hco_code  = code_value;
begin
   --
   tmpvar:=0;
   --
   if code_value is not null
   then open  get_code_seq;
        fetch get_code_seq into tmpVar;
        if   get_code_seq%notfound
        then close get_code_seq;
        else close get_code_seq;
        end if;
   end if;
   --
   return tmpVar;
   --
exception
  when no_data_found
  then return 0;
  when others
  then return 0;
end;


-------------------------------------------------------------------------------

/* MAIN */

  -----------------------------------------------------------------------------
  -- Function to get the <owner> of a database object (table,view,cluster)
  -- (PRIVATE)
  --
  FUNCTION get_owner
	( a_object_name	IN	VARCHAR2
  ) RETURN VARCHAR2 AS

  /* either user owns the object (table,view,cluster) */
    CURSOR c_uo IS
      SELECT user
      FROM   user_objects
      WHERE  object_name = upper( a_object_name)
        AND  object_type <> 'SYNONYM';

 /* or user has the use of a synonym for an object owned by another user */
    CURSOR c_as IS
      SELECT table_owner
      FROM   all_synonyms
      WHERE  synonym_name = upper( a_object_name);

 /* or user has no access to an object with this name */
    v_owner VARCHAR2(30);
    b_found BOOLEAN DEFAULT FALSE;

  BEGIN
    dbms_output.put_line( 'get_owner( '||a_object_name||')');

    OPEN  c_uo;
    FETCH c_uo INTO v_owner;
    b_found := c_uo%FOUND;
    CLOSE c_uo;
    IF    (NOT b_found) THEN
      OPEN  c_as;
      FETCH c_as INTO v_owner;
      b_found := c_as%FOUND;
      CLOSE c_as;
    END IF; 

    dbms_output.put_line( 'RETURN( '||v_owner||')');
    RETURN( v_owner);
  END get_owner;

BEGIN  /* mai - automatic variables */
  /*
    return the Oracle user who is owner of the MAI application
    (use 'DEFECTS' as the sample HIGHWAYS object)
  */
  g_application_owner := get_owner( 'DEFECTS');
  IF    (g_application_owner IS NULL) THEN
    raise_application_error( -20000 ,'MAI.G_APPLICATION_OWNER is null.');
  END IF;

  /* return the language under which the application is running */
  g_language := 'ENGLISH';

  /* instantiate common error messages */

END mai;
/

