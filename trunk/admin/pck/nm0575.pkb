CREATE OR REPLACE PACKAGE BODY nm0575
AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm0575.pkb-arc   2.1   Dec 03 2007 08:05:36   ptanava  $
--       Module Name      : $Workfile:   nm0575.pkb  $
--       Date into PVCS   : $Date:   Dec 03 2007 08:05:36  $
--       Date fetched Out : $Modtime:   Dec 03 2007 07:59:24  $
--       PVCS Version     : $Revision:   2.1  $
--       Based on SCCS version : 1.6

--   Author : Graeme Johnson

-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------

/* History
  30.11.07 PT complete rewrite of close logic. now closes partially with better performance
                todo: the gaz query unchanged and slow, should be possible to replace with bits from the new close logic
*/

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000)  := '"$Revision:   2.1  $"';
  g_package_name CONSTANT varchar2(30)    := 'nm0575';
  
  subtype id_type is nm_members.nm_ne_id_in%type;
  subtype mp_type is nm_members.nm_begin_mp%type;

  --g_network_placement_array  nm_placement_array; -- referred to when processing assets to close/delete     
  g_tab_selected_categories  nm3type.tab_varchar4; -- populated by the form


  g_tab_selected_xsps        nm3type.tab_varchar4; -- populated by the form
          
  g_current_result_set_id    nm_gaz_query_item_list.NGQI_JOB_ID%TYPE;
  
  g_delete                   CONSTANT VARCHAR2(1) := 'D';
  g_close                    CONSTANT VARCHAR2(1) := 'C';
  
  g_success_message          CONSTANT nm_errors.ner_descr%TYPE :=   hig.get_ner(pi_appl => 'HIG'
                                                                               ,pi_id  => 95).ner_descr;
                                                                               
                                                                               
  -- PT new logic module variables                                                               
  mt_inv_categories nm_code_tbl;
  mt_inv_types      nm_code_tbl;
  m_nte_job_id      nm_nw_temp_extents.nte_job_id%type;
  
  
  procedure close_member_record(
     p_action in varchar2
    ,p_effective_date in date
    ,p_ne_id_in in id_type
    ,p_ne_id_of in id_type
    ,p_begin_mp in mp_type
    ,p_start_date in date
  );
                                                                                 
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN varchar2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN varchar2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--


-- this populates the nm0575_possible_xsps temp table
-- called in the form when the Asset Category Selected flag is changed in the second tab
PROCEDURE set_g_tab_selected_categories(pi_tab_selected_categories IN nm3type.tab_varchar4)
IS
  i binary_integer;
  
BEGIN
  nm3dbg.debug_on;
  nm3dbg.putln(g_package_name||'.set_g_tab_selected_categories('
    ||'pi_tab_selected_categories.count='||pi_tab_selected_categories.count
    ||')');
  nm3dbg.ind;
  
  mt_inv_categories := new nm_code_tbl();
  i := pi_tab_selected_categories.first;
  while i is not null loop
    mt_inv_categories.extend;
    mt_inv_categories(mt_inv_categories.count) := pi_tab_selected_categories(i);
    i := pi_tab_selected_categories.next(i);
  end loop;
  
  delete from nm0575_possible_xsps
  where xsp_value not in (
    select r.xsr_x_sect_value
    from
       nm_xsp_restraints r
      ,nm_inv_types t
    where r.xsr_ity_inv_code = t.nit_inv_type
      and t.nit_category in (select column_value from table(cast(get_inv_categories_tbl as nm_code_tbl)))
    );
  nm3dbg.putln('nm0575_possible_xsps delete  count: '||sql%rowcount);
--
  -- 
  merge into nm0575_possible_xsps d
  using (
  select
     r.xsr_x_sect_value xsp_value
    ,count(*) xsp_restraint_count
    ,(select min(nwx_descr) from nm_nw_xsp where nwx_x_sect = r.xsr_x_sect_value) xsp_descr
    ,'N' xsp_selected
  from
     nm_xsp_restraints r
    ,nm_inv_types t
  where r.xsr_ity_inv_code = t.nit_inv_type
    and t.nit_category in (select column_value from table(cast(get_inv_categories_tbl as nm_code_tbl)))
  group by
     r.xsr_x_sect_value
  ) s
  on (d.xsp_value = s.xsp_value)
  when matched then
    update set
       d.xsp_restraint_count = s.xsp_restraint_count
      ,d.xsp_descr = s.xsp_descr
  when not matched then
    insert (xsp_value, xsp_descr, xsp_restraint_count, xsp_selected)
    values (s.xsp_value, s.xsp_descr, s.xsp_restraint_count, s.xsp_selected);
  nm3dbg.putln('nm0575_possible_xsps merge  count: '||sql%rowcount);

  g_tab_selected_categories := pi_tab_selected_categories;
 
  nm3dbg.deind;
exception
  when others then
    nm3dbg.puterr(sqlerrm||': '||g_package_name||'.set_g_tab_selected_categories('
      ||'pi_tab_selected_categories.count='||pi_tab_selected_categories.count
      ||')');
    raise;
  
END set_g_tab_selected_categories;


FUNCTION setup_gaz_query(pi_source_ne_id       IN nm_gaz_query.ngq_source_id%TYPE
                        ,pi_begin_mp           IN nm_gaz_query.ngq_begin_mp%TYPE
                        ,pi_end_mp             IN nm_gaz_query.ngq_end_mp%TYPE
                        ,pi_ambig_sub_class    IN nm_gaz_query.ngq_ambig_sub_class%TYPE) RETURN nm_gaz_query.ngq_id%TYPE IS

   l_rec_ngq nm_gaz_query%ROWTYPE;
   l_seq     PLS_INTEGER;
   
   
   PROCEDURE add_xsp_restrictions(pi_ngq_id nm_gaz_query.ngq_id%TYPE) IS


     l_last_ngqt nm_gaz_query_types.ngqt_seq_no%TYPE := -1;
     l_operator  VARCHAR2(3);
     l_seq       pls_integer :=0;

   BEGIN
     nm3dbg.putln(g_package_name||'.setup_gaz_query.add_xsp_restrictions('
       ||'pi_ngq_id='||pi_ngq_id
       ||')');
      --
      -- loop around all asset types for the gaz query and join to selected XSP types
      -- and create the necessary NM_GAZ_QUERY_ATTRIBS and NM_GAZ_QUERY_VALUES records
      --
      FOR t IN (select * 
                from  nm_gaz_query_types
                     ,nm0575_possible_xsps
                     ,nm_inv_types_all
                where ngqt_ngq_id = pi_ngq_id
                and   nit_inv_type = ngqt_item_type
                and   nit_x_sect_allow_flag = 'Y'  -- only add xsp restriction to those asset types that allow it
                and   xsp_selected = 'Y'
                order by ngqt_ngq_id, ngqt_seq_no) LOOP
               
           --
           -- if this is the first record for the asset type to be processed
           -- the treat different to if it is second, third, fourth etc
           --
           IF l_last_ngqt = t.ngqt_seq_no THEN     
                l_operator := 'OR';
           ELSE
                l_operator := 'AND';
                l_seq := 0;
           END IF;
                                                      
           l_last_ngqt := t.ngqt_seq_no;
           l_seq := l_seq +1;
                           
           insert into nm_gaz_query_attribs(ngqa_ngq_id
                                           ,ngqa_ngqt_seq_no
                                           ,ngqa_seq_no
                                           ,ngqa_attrib_name
                                           ,ngqa_operator
                                           ,ngqa_condition)
            values (t.ngqt_ngq_id
                   ,t.ngqt_seq_no
                   ,l_seq
                   ,'IIT_X_SECT'
                   ,l_operator
                   ,'=');
                   
            insert into nm_gaz_query_values(ngqv_ngq_id
                                           ,ngqv_ngqt_seq_no
                                           ,ngqv_ngqa_seq_no
                                           ,ngqv_sequence
                                           ,ngqv_value)
                        VALUES                                       
                               (t.ngqt_ngq_id
                               ,t.ngqt_seq_no
                               ,l_seq
                               ,1
                               ,t.xsp_value);
        
         END LOOP;        
        
        commit;
   exception
    when others then
      nm3dbg.puterr(sqlerrm||': '||g_package_name||'.do_query('
        ||'pi_ngq_id='||pi_ngq_id
        ||', l_last_ngqt='||l_last_ngqt
        ||', l_operator='||l_operator
        ||', l_seq='||l_seq
        ||')');
      raise;
   
   END add_xsp_restrictions;
 
BEGIN
  nm3dbg.putln(g_package_name||'.setup_gaz_query('
    ||'pi_source_ne_id='||pi_source_ne_id
    ||', pi_begin_mp='||pi_begin_mp
    ||', pi_end_mp='||pi_end_mp
    ||', pi_ambig_sub_class='||pi_ambig_sub_class
    ||')');
  nm3dbg.ind;
    
   l_rec_ngq := Null;
   
   l_rec_ngq.ngq_id                  := nm3seq.next_ngq_id_seq;

   nm3gaz_qry.set_ngq_source_etc(pi_ne_id         => pi_source_ne_id
                                ,po_ngq_source_id => l_rec_ngq.ngq_source_id
                                ,po_ngq_source    => l_rec_ngq.ngq_source
                                ,po_ngq_query_all_items => l_rec_ngq.ngq_query_all_items); 
  
   l_rec_ngq.ngq_open_or_closed      := nm3gaz_qry.c_closed_query;
   l_rec_ngq.ngq_items_or_area       := nm3gaz_qry.c_items_query;
   l_rec_ngq.ngq_begin_mp            := pi_begin_mp;
   l_rec_ngq.ngq_begin_datum_ne_id   := Null;
   l_rec_ngq.ngq_begin_datum_offset  := Null;
   l_rec_ngq.ngq_end_mp              := pi_end_mp;
   l_rec_ngq.ngq_end_datum_ne_id     := Null;
   l_rec_ngq.ngq_end_datum_offset    := Null;
   l_rec_ngq.ngq_ambig_sub_class     := pi_ambig_sub_class;
   nm3ins.ins_ngq (l_rec_ngq);


--
-- set a global placement array that stores the network that the gaz
-- query was restricted on
-- this is used when processing assets in order to ascertain whether
-- a given asset is placed over just the network we restricted on
-- or it is only partially over this network
-- 

  -- PT comment out
--    IF l_rec_ngq.ngq_query_all_items = 'N' THEN
--     g_network_placement_array := nm3pla.get_placement_from_ne(p_ne_id_in => l_rec_ngq.ngq_source_id);
--    END IF;
--    
  -- the temp extent gives the route members adjusted for begin/end 
  nm3extent.create_temp_ne (
     pi_source_id => pi_source_ne_id
    ,pi_source    => 'ROUTE'
    ,pi_begin_mp  => pi_begin_mp
    ,pi_end_mp    => pi_end_mp
    ,po_job_id    => m_nte_job_id
  );
  nm3dbg.putln('m_nte_job_id='||m_nte_job_id);


--nm_debug.debug_on;
--nm3debug.debug_ngq(l_rec_ngq);
   
--
   nm3gaz_qry.add_inv_types_for_categories(pi_ngq_id              => l_rec_ngq.ngq_id
                                          ,pi_tab_categories      => g_tab_selected_categories
                                          ,pi_exclude_off_network => TRUE);


--
-- set up some restrictions on XSPs to our gaz query
--
 add_xsp_restrictions(pi_ngq_id => l_rec_ngq.ngq_id); 

   
  nm3dbg.deind;
   RETURN(l_rec_ngq.ngq_id);

exception
  when others then
    nm3dbg.puterr(sqlerrm||': '||g_package_name||'.do_query('
      ||'pi_source_ne_id='||pi_source_ne_id
      ||', pi_begin_mp='||pi_begin_mp
      ||', pi_end_mp='||pi_end_mp
      ||', pi_ambig_sub_class='||pi_ambig_sub_class
      ||', g_tab_selected_categories.count='||g_tab_selected_categories.count
      ||')');
    raise;                                         

END setup_gaz_query;
--
-----------------------------------------------------------------------------
--
FUNCTION get_current_result_set_id RETURN nm_gaz_query_item_list.NGQI_JOB_ID%TYPE IS

BEGIN
  RETURN(g_current_result_set_id);
END get_current_result_set_id;
--
-----------------------------------------------------------------------------
--
PROCEDURE do_query(pi_source_ne_id        IN nm_gaz_query.ngq_source_id%TYPE
                  ,pi_begin_mp            IN nm_gaz_query.ngq_begin_mp%TYPE
                  ,pi_end_mp              IN nm_gaz_query.ngq_end_mp%TYPE
                  ,pi_ambig_sub_class     IN nm_gaz_query.ngq_ambig_sub_class%TYPE) IS


 l_ngq_id nm_gaz_query.ngq_id%TYPE;

 
BEGIN
  nm3dbg.debug_on; nm3dbg.timing_on;
  nm3dbg.putln(g_package_name||'.do_query('
    ||'pi_source_ne_id='||pi_source_ne_id
    ||', pi_begin_mp='||pi_begin_mp
    ||', pi_end_mp='||pi_end_mp
    ||', pi_ambig_sub_class='||pi_ambig_sub_class
    ||')');
  nm3dbg.ind;
 --
 -- a precursor to calling this procedure is that the
 -- set_g_tab_selected_categories has been called
 -- if it's not been set then we just won't bother doing anything cos
 -- there would be no results returned by gaz query
 --
 
  nm3dbg.putln('g_tab_selected_categories.COUNT='||g_tab_selected_categories.COUNT); 
 IF  g_tab_selected_categories.COUNT >0 THEN

   l_ngq_id :=  setup_gaz_query(pi_source_ne_id       => pi_source_ne_id
                               ,pi_begin_mp           => pi_begin_mp
                               ,pi_end_mp             => pi_end_mp
                               ,pi_ambig_sub_class    => pi_ambig_sub_class);
   nm3dbg.putln('l_ngq_id='||l_ngq_id);
                                     
   g_current_result_set_id := nm3gaz_qry.perform_query (pi_ngq_id => l_ngq_id);
   nm3dbg.putln('g_current_result_set_id='||g_current_result_set_id);
--   po_tab_summary_results := get_tab_summary_results;
 END IF;
  
  nm3dbg.deind;
exception
  when others then
    nm3dbg.puterr(sqlerrm||': '||g_package_name||'.do_query('
      ||'pi_source_ne_id='||pi_source_ne_id
      ||', pi_begin_mp='||pi_begin_mp
      ||', pi_end_mp='||pi_end_mp
      ||', pi_ambig_sub_class='||pi_ambig_sub_class
      ||', g_tab_selected_categories.count='||g_tab_selected_categories.count
      ||')');
    raise;
    
END do_query;                       

--
-----------------------------------------------------------------------------
--
PROCEDURE clear_event_log IS

BEGIN

delete from nm0575_event_log;
commit;

END;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_tab_asset_types(pi_tab_asset_types  IN nm3type.tab_varchar4
                                 ,pi_action           IN VARCHAR2
                                 ,pi_process_partial  IN VARCHAR2) IS

  
  i binary_integer;
  l_effective_date date := nm3user.get_effective_date;
  
  t_code          nm_code_tbl := new nm_code_tbl();
  t_iit_id        nm_id_tbl := new nm_id_tbl();
  t_iig_item_id   nm_id_tbl;
  t_iig_top_id    nm_id_tbl;
  
  l_main_count      pls_integer := 0;
  l_partial_count   pls_integer := 0;
  l_child_count     pls_integer := 0;
  r_log           nm0575_event_log%rowtype;
  l_action        varchar2(20);
 


BEGIN
  nm3dbg.debug_on; nm3dbg.timing_on;
  nm3dbg.putln(g_package_name||'.process_tab_asset_types('
    ||'pi_tab_asset_types.count='||pi_tab_asset_types.count
    ||', pi_action='||pi_action
    ||', pi_process_partial='||pi_process_partial
    ||', m_nte_job_id='||m_nte_job_id
    ||')');
  nm3dbg.ind;
  
  -- effective date check
  if l_effective_date = trunc(sysdate) then
    null;
  else
    raise_application_error(-20001,
      'Effective date must be current date');
  end if;

  
  
  -- set the inv_types to be used in the asset select
  i := pi_tab_asset_types.first;
  while i is not null loop
    t_code.extend;
    t_code(t_code.last) := pi_tab_asset_types(i);
    i := pi_tab_asset_types.next(i);
    
  end loop;
  nm3dbg.putln('t_code.count='||t_code.count);
  
  
  -- todo: store the next cursor results in a temp table (without the nm_member values)
  -- then just run everything as a series of bulk statements
  --  the current solution is only to avoid creating the temp table - needs some general core planning first.
  
  -- open the main assets query
  -- this closes / resizes all placements (including potential child placements)
  --  (the top distinct removes duplicates caused by multiples from nm_inv_item_groupings table
  --   the disticnt below removes duplicate point items - create by falling element start/end)
  for r in (
    select q2.*
      ,row_number() over (partition by q2.nm_ne_id_in order by 1) iit_rownum
    from (
    select distinct
       q.iit_ne_id nm_ne_id_in
      ,q.nm_ne_id_of
      ,q.nm_begin_mp
      ,q.nm_start_date
      ,q.nm_admin_unit
      ,q.nm_type
      ,q.nm_obj_type
      ,q.nm_cardinality
      ,q.nm_seq_no
      ,q.nm_seg_no
      ,q.excluded_member_count
      ,g.iig_parent_id
      ,case
       when q.nm_begin_mp < q.nte_begin_mp then q.nm_begin_mp
       else null
       end keep_begin_mp
      ,case
       when q.nm_begin_mp < q.nte_begin_mp then q.nte_begin_mp
       else null
       end keep_end_mp
      ,case
       when q.nm_end_mp > q.nte_end_mp then q.nte_end_mp
       else null
       end keep_begin_mp2
      ,case
       when q.nm_end_mp > q.nte_end_mp then q.nm_end_mp
       else null
       end keep_end_mp2
    from (
    select distinct
       m.*
      ,te.nte_ne_id_of
      ,te.nte_begin_mp
      ,te.nte_end_mp
      ,count(nvl2(te.nte_ne_id_of, null, 1)) over (partition by m.iit_ne_id) excluded_member_count
    from
       (
        select
           i.iit_ne_id
          ,im.nm_ne_id_of
          ,im.nm_begin_mp
          ,im.nm_end_mp
          ,im.nm_start_date
          ,im.nm_admin_unit
          ,im.nm_type
          ,im.nm_obj_type
          ,im.nm_cardinality
          ,im.nm_seq_no
          ,im.nm_seg_no
        from
           ( 
            select distinct m.nm_ne_id_in
            from
               nm_nw_temp_extents xe
              ,nm_members m
            where xe.nte_ne_id_of = m.nm_ne_id_of
              and xe.nte_job_id = m_nte_job_id
              and m.nm_type = 'I'
            group by m.nm_ne_id_in
           ) em
          ,nm_inv_items i
          ,nm_members im
        where em.nm_ne_id_in = i.iit_ne_id
          and i.iit_ne_id = im.nm_ne_id_in
          and i.iit_inv_type in (select column_value from table(cast(t_code as nm_code_tbl)))
          and (i.iit_x_sect is null 
            or i.iit_x_sect in (select x2.xsp_value from nm0575_possible_xsps x2 where x2.xsp_selected = 'Y'))
       ) m
      ,(select * from nm_nw_temp_extents where nte_job_id = m_nte_job_id) te
    where m.nm_ne_id_of = te.nte_ne_id_of (+)
      and m.nm_begin_mp <= te.nte_end_mp (+)
      and m.nm_end_mp >= te.nte_begin_mp (+)
    ) q
    ,nm_inv_item_groupings g
    where q.nte_ne_id_of is not null
      and q.iit_ne_id = g.iig_parent_id (+)
    ) q2
  )
  
  -- start of the main asset placements loop
  loop
    l_main_count := l_main_count + 1;
--     nm3dbg.putln(l_main_count||'=(nm_ne_id_in='||r.nm_ne_id_in
--       ||', nm_ne_id_of='||r.nm_ne_id_of
--       ||', nm_begin_mp='||r.nm_begin_mp
--       ||', excluded_member_count='||r.excluded_member_count
--       ||', iig_parent_id='||r.iig_parent_id
--       ||', keep_begin_mp='||r.keep_begin_mp
--       ||', keep_end_mp='||r.keep_end_mp
--       ||', keep_begin_mp2='||r.keep_begin_mp2
--       ||', keep_end_mp2='||r.keep_end_mp2
--       ||')');
      
       
    -- close the current asset placement
    close_member_record(
       p_action   => pi_action
      ,p_effective_date => l_effective_date
      ,p_ne_id_in => r.nm_ne_id_in
      ,p_ne_id_of => r.nm_ne_id_of
      ,p_begin_mp => r.nm_begin_mp
      ,p_start_date => r.nm_start_date
    );
      
    
    -- create the first not included part
    if r.keep_begin_mp is not null then
      insert into nm_members_all (
        nm_ne_id_in, nm_ne_id_of, nm_type, nm_obj_type, nm_begin_mp
        , nm_start_date, nm_end_mp, nm_cardinality, nm_admin_unit, nm_seq_no, nm_seg_no
      )
      values (
        r.nm_ne_id_in, r.nm_ne_id_of, r.nm_type, r.nm_obj_type, r.keep_begin_mp
        , l_effective_date, r.keep_end_mp, r.nm_cardinality, r.nm_admin_unit, r.nm_seq_no, r.nm_seg_no
      );
    end if;
    
    -- create the second not included part
    if r.keep_begin_mp2 is not null then
      insert into nm_members_all (
        nm_ne_id_in, nm_ne_id_of, nm_type, nm_obj_type, nm_begin_mp
        , nm_start_date, nm_end_mp, nm_cardinality, nm_admin_unit, nm_seq_no, nm_seg_no
      )
      values (
        r.nm_ne_id_in, r.nm_ne_id_of, r.nm_type, r.nm_obj_type, r.keep_begin_mp2
        , l_effective_date, r.keep_end_mp2, r.nm_cardinality, r.nm_admin_unit, r.nm_seq_no, r.nm_seg_no
      );
    end if;
    
    
    
    
    -- asset (and child assets) processing continues here for wholly closed assets
    
    -- the asset is wholly closed
    if r.excluded_member_count = 0
      and r.keep_begin_mp is null
      and r.keep_begin_mp2 is null
      and r.iit_rownum = 1
    then
    
       -- store the parent asset id for later forall closure of the inv_items records
      t_iit_id.extend;
      t_iit_id(t_iit_id.last) := r.nm_ne_id_in;
      
      
      -- it is a parent asset
      if r.iig_parent_id is not null then
        
        
        
        -- bulk collect all the child item ids
        select g.iig_item_id, g.iig_top_id
        bulk collect into t_iig_item_id, t_iig_top_id
        from nm_inv_item_groupings_all g
        connect by prior g.iig_item_id = g.iig_parent_id
        start with g.iig_parent_id = r.iig_parent_id;
        
        l_child_count := l_child_count + t_iig_item_id.count;
        
        
        -- close the hierarchy definitions
        if pi_action = 'C' then
          forall i in 1 .. t_iig_item_id.count  
          update nm_inv_item_groupings_all g
            set g.iig_end_date = l_effective_date
          where g.iig_item_id = t_iig_item_id(i)
            and g.iig_top_id = t_iig_top_id(i);
        
        else
          forall i in 1 .. t_iig_item_id.count
          delete from nm_inv_item_groupings_all g
          where g.iig_item_id = t_iig_item_id(i)
            and g.iig_top_id = t_iig_top_id(i);
        
        end if;
        
        
        -- close the child placements
        if pi_action = 'C' then
          forall i in 1 .. t_iig_item_id.count  
          update nm_members_all m
            set m.nm_end_date = l_effective_date
          where m.nm_ne_id_in = t_iig_item_id(i)
            and m.nm_end_date is not null;
        
        else
          forall i in 1 .. t_iig_item_id.count  
          delete from nm_members_all m
          where m.nm_ne_id_in = t_iig_item_id(i)
            and m.nm_end_date is not null;
        
        end if;
        
        -- close the child invitem records
        if pi_action = 'C' then
          forall i in 1 .. t_iig_item_id.count
          update nm_inv_items_all i
            set i.iit_end_date = l_effective_date
          where i.iit_ne_id = t_iig_item_id(i)
            and i.iit_end_date is not null;
        
        else
          forall i in 1 .. t_iig_item_id.count  
          delete from nm_inv_items_all i
          where i.iit_ne_id = t_iig_item_id(i)
            and i.iit_end_date is not null;
        
        end if;
        
        -- close child doc assocs
        forall i in 1 .. t_iig_item_id.count
        delete from doc_assocs
        where das_rec_id = to_char(t_iig_item_id(i))
          and das_table_name in ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS');
        
        
      end if; -- it is a parent asset
      
        
      -- close current record doc assocs
      delete from doc_assocs
      where das_rec_id = to_char(r.iig_parent_id)
        and das_table_name in ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS'); 
        
        
    else
      l_partial_count := l_partial_count + 1;
    
      
    end if; -- wholly closed asset
    
    
  end loop;
  nm3dbg.putln('l_main_count='||l_main_count);
  
  
  
  -- close all memberless assets
  if pi_action = 'C' then
    forall i in 1 .. t_iit_id.count
    update nm_inv_items_all
    set iit_end_date = l_effective_date
    where iit_ne_id = t_iit_id(i)
      and iit_end_date is not null;
  
  -- delete
  elsif pi_action = 'D' then
    forall i in 1 .. t_iit_id.count
    delete from nm_inv_items_all
    where iit_ne_id = t_iit_id(i)
      and iit_end_date is not null;
      
  end if;
  
  nm3dbg.putln('l_whole_count='||t_iit_id.count);
  nm3dbg.putln('l_partial_count='||l_partial_count);
  nm3dbg.putln('l_child_count='||l_child_count);
  
  r_log.log_action      := pi_action;
  r_log.log_error_flag  := 'N';
  if pi_action = 'C' then
    l_action := 'end dated';
    r_log.log_iit_ne_id   := 0;
  else
    l_action := 'deleted';
    r_log.log_iit_ne_id   := 10;
  end if;
  
  r_log.log_iit_ne_id   := r_log.log_iit_ne_id + 1;
  r_log.log_message     := l_main_count||' placement records '||l_action;
  insert into nm0575_event_log values r_log;
  
  r_log.log_iit_ne_id   := r_log.log_iit_ne_id + 1;
  r_log.log_message     := t_iit_id.count||' assets items '||l_action;
  insert into nm0575_event_log values r_log;
  
  r_log.log_iit_ne_id   := r_log.log_iit_ne_id + 1;
  r_log.log_message     := l_partial_count||' assets items partially '||l_action;
  insert into nm0575_event_log values r_log;
  
  r_log.log_iit_ne_id   := r_log.log_iit_ne_id + 1;
  r_log.log_message     := l_child_count||' child items '||l_action;
  insert into nm0575_event_log values r_log;
 
 
--   raise zero_divide;
 
  nm3dbg.deind;
exception
  when others then
    nm3dbg.puterr(sqlerrm||': '||g_package_name||'.process_tab_asset_types('
      ||'pi_tab_asset_types.count='||pi_tab_asset_types.count
      ||', pi_action='||pi_action
      ||', pi_process_partial='||pi_process_partial
      ||')');
    raise;
 


END;
--
-----------------------------------------------------------------------------
--
PROCEDURE tidy_up IS

BEGIN

 delete from nm_gaz_query_item_list
 where  ngqi_job_id = g_current_result_set_id;
 
 
  mt_inv_categories := null;
  mt_inv_types      := null;
  m_nte_job_id      := null;
 
 commit;

END tidy_up;





  function get_inv_categories_tbl
  return nm_code_tbl
  is
    l_count pls_integer;
  begin
    l_count := mt_inv_categories.count;
    return mt_inv_categories;
  exception
    when collection_is_null then
      mt_inv_categories := new nm_code_tbl();
      return mt_inv_categories;
  end;
  
  
  function get_inv_types_tbl
  return nm_code_tbl
  is
    l_count pls_integer;
  begin
    l_count := mt_inv_types.count;
    return mt_inv_types;
  exception
    when collection_is_null then
      mt_inv_types := new nm_code_tbl();
      return mt_inv_types;
  end;
  
  
  
  
  -- this sets the mt_inv_types and also populates the mt_child_types
  procedure set_inv_types_tbl(p_tbl in nm_code_tbl)
  is
  begin
    mt_inv_types := p_tbl;

  end;
  
  
  
  
  procedure close_member_record(
     p_action in varchar2
    ,p_effective_date in date
    ,p_ne_id_in in id_type
    ,p_ne_id_of in id_type
    ,p_begin_mp in mp_type
    ,p_start_date in date
  )
  is
  begin
    -- end date
    if p_action = 'C' then
      update nm_members_all
      set nm_end_date = p_effective_date
      where nm_ne_id_in = p_ne_id_in
        and nm_ne_id_of = p_ne_id_of
        and nm_begin_mp = p_begin_mp
        and nm_start_date = p_start_date
        and nm_end_date is not null;
--       if sql%rowcount = 0 then
--         raise no_data_found;
--       end if;
    
    -- delete
    elsif p_action = 'D' then
    
      -- delete old member
      delete from nm_members_all
      where nm_ne_id_in = p_ne_id_in
        and nm_ne_id_of = p_ne_id_of
        and nm_begin_mp = p_begin_mp
        and nm_start_date = p_start_date
        and nm_end_date is not null;
        
    end if;
  end;
    
END nm0575;
/


