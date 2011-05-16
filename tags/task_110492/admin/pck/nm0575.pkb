CREATE OR REPLACE PACKAGE BODY nm0575
AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm0575.pkb-arc   2.8   May 16 2011 14:42:24   Steve.Cooper  $
--       Module Name      : $Workfile:   nm0575.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:42:24  $
--       Date fetched Out : $Modtime:   Apr 01 2011 10:40:02  $
--       PVCS Version     : $Revision:   2.8  $
--       Based on SCCS version : 1.6

--   Author : Graeme Johnson

-----------------------------------------------------------------------------
-- Copyright (c) exor corporation ltd, 2006
-----------------------------------------------------------------------------

/* History
  30.11.07 PT complete rewrite of close logic for better performance. logic changed, now closes assets partially
*/

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000)  := '"$Revision:   2.8  $"';
  g_package_name CONSTANT varchar2(30)    := 'nm0575';
  
  subtype id_type is nm_members.nm_ne_id_in%type;
  subtype mp_type is nm_members.nm_begin_mp%type;

  --g_network_placement_array  nm_placement_array; -- referred to when processing assets to close/delete     
  g_tab_selected_categories  nm3type.tab_varchar4; -- populated by the form

  
  g_delete                   CONSTANT VARCHAR2(1) := 'D';
  g_close                    CONSTANT VARCHAR2(1) := 'C';
  
  g_success_message          CONSTANT nm_errors.ner_descr%TYPE :=   hig.get_ner(pi_appl => 'HIG'
                                                                               ,pi_id  => 95).ner_descr;
                                                                               
  g_include_partial                   VARCHAR2(1) := 'Y';
  g_cached_results                    nm_id_code_meaning_tbl := new nm_id_code_meaning_tbl ()  ;

  -- PT new logic module variables
  mt_inv_categories nm_code_tbl;
  mt_inv_types      nm_code_tbl;
  m_nte_job_id      nm_nw_temp_extents.nte_job_id%type;
  m_xsp_changed     boolean := false;
  
  
  procedure close_member_record(
     p_action in varchar2
    ,p_effective_date in date
    ,p_ne_id_in in id_type
    ,p_ne_id_of in id_type
    ,p_begin_mp in mp_type
    ,p_start_date in date
  );
  
  function are_tables_equal(
     pt_1 in nm3type.tab_varchar4
    ,pt_2 in nm3type.tab_varchar4
  ) return boolean;
                                                                                 
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
  nm3dbg.putln(g_package_name||'.set_g_tab_selected_categories('
    ||'pi_tab_selected_categories.count='||pi_tab_selected_categories.count
    ||')');
  nm3dbg.ind;
  
  m_xsp_changed := true;
  
  
  -- categories cache table
  mt_inv_categories := new nm_code_tbl();
  i := pi_tab_selected_categories.first;
  while i is not null loop
    mt_inv_categories.extend;
    mt_inv_categories(mt_inv_categories.count) := pi_tab_selected_categories(i);
    i := pi_tab_selected_categories.next(i);
  end loop;
  
  
  -- inv types cache table
  select t.nit_inv_type
  bulk collect into mt_inv_types
  from
     nm_inv_types t
  where t.nit_category in (select column_value from table(cast(get_inv_categories_tbl as nm_code_tbl)));
  
  
  -- xsp temp table
  delete from nm0575_possible_xsps
  where xsp_value not in (
    select r.xsr_x_sect_value
    from
       nm_xsp_restraints r
    where r.xsr_ity_inv_code in (select column_value from table(cast(get_inv_types_tbl as nm_code_tbl)))
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
  where r.xsr_ity_inv_code in (select column_value from table(cast(get_inv_types_tbl as nm_code_tbl)))
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
--
-----------------------------------------------------------------------------------------------------------------------
--
PROCEDURE cache_results
IS
BEGIN
--
  g_cached_results.DELETE;
--
    WITH all_data AS
           (  SELECT nm_ne_id_in
                   , nm_obj_type
                   , partial
                FROM (
                SELECT nm_ne_id_in
                      , nm_obj_type
                      , max(partial) partial
                          FROM (
                                SELECT q2.*
                                     , ROW_NUMBER ( ) OVER (PARTITION BY q2.nm_ne_id_in ORDER BY 1) iit_rownum
                                     , CASE
                                         WHEN ( keep_begin_mp  IS NOT NULL
                                            OR  keep_end_mp    IS NOT NULL
                                            OR  keep_begin_mp2 IS NOT NULL
                                            OR  keep_end_mp2   IS NOT NULL )
                                         THEN
                                           1
                                         ELSE
                                           0
                                       END partial
                                  FROM (SELECT DISTINCT
                                               q.iit_ne_id nm_ne_id_in
                                             , q.nm_ne_id_of
                                             , q.nm_begin_mp
                                             , q.nm_end_mp
                                             , q.nm_start_date
                                             , q.nm_admin_unit
                                             , q.nm_type
                                             , q.nm_obj_type
                                             , q.nm_cardinality
                                             , q.nm_seq_no
                                             , q.nm_seg_no
                                             , q.excluded_member_count
                                             , g.iig_parent_id
                                             , CASE WHEN q.nm_begin_mp < q.nte_begin_mp THEN q.nm_begin_mp ELSE NULL END  keep_begin_mp
                                             , CASE WHEN q.nm_begin_mp < q.nte_begin_mp THEN q.nte_begin_mp ELSE NULL END keep_end_mp
                                             , CASE WHEN q.nm_end_mp > q.nte_end_mp THEN q.nte_end_mp ELSE NULL END       keep_begin_mp2
                                             , CASE WHEN q.nm_end_mp > q.nte_end_mp THEN q.nm_end_mp ELSE NULL END        keep_end_mp2
                                          FROM (SELECT DISTINCT
                                                       m.*
                                                     , te.nte_ne_id_of
                                                     , te.nte_begin_mp
                                                     , te.nte_end_mp
                                                     , COUNT ( NVL2 ( te.nte_ne_id_of, NULL, 1 ) ) OVER (PARTITION BY m.iit_ne_id) excluded_member_count
                                                  FROM (SELECT i.iit_ne_id
                                                             , im.nm_ne_id_of
                                                             , im.nm_begin_mp
                                                             , im.nm_end_mp
                                                             , im.nm_start_date
                                                             , im.nm_admin_unit
                                                             , im.nm_type
                                                             , im.nm_obj_type
                                                             , im.nm_cardinality
                                                             , im.nm_seq_no
                                                             , im.nm_seg_no
                                                          FROM (  SELECT DISTINCT m.nm_ne_id_in
                                                                    FROM nm_nw_temp_extents xe
                                                                       , nm_members m
                                                                   WHERE xe.nte_ne_id_of = m.nm_ne_id_of
                                                                     AND xe.nte_job_id = m_nte_job_id
                                                                     AND m.nm_type = 'I'
                                                                GROUP BY m.nm_ne_id_in) em
                                                             , nm_inv_items i
                                                             , nm_members im
                                                         WHERE em.nm_ne_id_in = i.iit_ne_id
                                                           AND i.iit_ne_id = im.nm_ne_id_in
                                                           AND i.iit_inv_type IN (SELECT COLUMN_VALUE FROM TABLE(CAST(get_inv_types_tbl AS nm_code_tbl)))
                                                           --and i.iit_inv_type = 'SPED'
                                                           AND ( i.iit_x_sect IS NULL
                                                             OR  i.iit_x_sect IN (SELECT x2.xsp_value
                                                                                    FROM nm0575_possible_xsps x2
                                                                                   WHERE x2.xsp_selected = 'Y') )) m
                                                     , (SELECT *
                                                          FROM nm_nw_temp_extents
                                                         WHERE nte_job_id = m_nte_job_id) te
                                                 WHERE m.nm_ne_id_of = te.nte_ne_id_of(+)
                                                   AND m.nm_begin_mp <= te.nte_end_mp(+)
                                                   AND m.nm_end_mp >= te.nte_begin_mp(+)) q
                                             , nm_inv_item_groupings g
                                         WHERE q.nte_ne_id_of IS NOT NULL
                                           AND ( q.nm_begin_mp = q.nm_end_mp
                                             OR  ( q.nm_begin_mp < q.nte_end_mp
                                              AND q.nm_end_mp > q.nte_begin_mp ) )
                                           AND ( q.nte_begin_mp < q.nte_end_mp
                                             OR  q.nm_begin_mp = q.nm_end_mp )
                                           AND q.iit_ne_id = g.iig_parent_id(+)) q2
                                           )
                      GROUP BY nm_ne_id_in
                             , nm_obj_type
                             )
            WHERE partial = CASE WHEN g_include_partial = 'N' THEN 0 ELSE partial END
            GROUP BY nm_ne_id_in
                   , nm_obj_type
                   , partial
                   )
        SELECT cast ( collect (nm_id_code_meaning_type ( nm_ne_id_in, nm_obj_type, partial ) ) as  nm_id_code_meaning_tbl )
          INTO g_cached_results
          FROM all_data;
END;

--
-----------------------------------------------------------------------------------------------------------------------
--

-- this populates the nm0575_matching_records
-- this is called form the form immediately before a query is run on the table
PROCEDURE do_query(
   pi_source_type        in varchar2
  ,pi_source_ne_id       IN nm_gaz_query.ngq_source_id%TYPE
  ,pi_begin_mp           IN nm_gaz_query.ngq_begin_mp%TYPE
  ,pi_end_mp             IN nm_gaz_query.ngq_end_mp%TYPE
  --,pi_ambig_sub_class    IN nm_gaz_query.ngq_ambig_sub_class%TYPE
)
IS
 l_ngq_id nm_gaz_query.ngq_id%TYPE;
 l_nte_source varchar2(20);
 l_tmp_count  pls_integer;

BEGIN
  nm3dbg.putln(g_package_name||'.do_query('
    ||', pi_source_type='||pi_source_type
    ||', pi_source_ne_id='||pi_source_ne_id
    ||', pi_begin_mp='||pi_begin_mp
    ||', pi_end_mp='||pi_end_mp
    ||', m_xsp_changed='||nm3dbg.to_char(m_xsp_changed)
--    ||', pi_ambig_sub_class='||pi_ambig_sub_class
    ||')');
  nm3dbg.ind;
  
  
  if pi_source_type = 'E' then
    l_nte_source := 'SAVED';
  else
    l_nte_source := 'ROUTE';
  end if;

  if m_xsp_changed then
    
    -- clear the previous temp extent
    if m_nte_job_id is not null then
      delete from nm_nw_temp_extents
      where nte_job_id = m_nte_job_id;
    end if;
    
    commit;
    execute immediate 'truncate table nm0575_matching_records';
    
    -- an area of interest is defined
    if pi_source_ne_id is not null then
    
      nm3extent.create_temp_ne (
         pi_source_id => pi_source_ne_id
        ,pi_source    => l_nte_source
        ,pi_begin_mp  => pi_begin_mp
        ,pi_end_mp    => pi_end_mp
        ,po_job_id    => m_nte_job_id
      );
      nm3dbg.putln('m_nte_job_id='||m_nte_job_id);
  
      
      if g_tab_selected_categories.count > 0 then
      
--        insert into nm0575_matching_records (
--          asset_category, asset_type, asset_type_descr, asset_count
--        )
--        select
--           t.nit_category asset_category
--          ,t.nit_inv_type asset_type
--          ,t.nit_descr asset_type_descr
--          ,count(*) asset_count
--        from (
--        select
--        distinct i.iit_ne_id, i.iit_inv_type
--        from
--           nm_nw_temp_extents xe
--          ,nm_members m
--          ,nm_inv_items i
--          ,(select column_value from table(cast(get_inv_types_tbl as nm_code_tbl))) xt 
--          ,(select x2.xsp_value from nm0575_possible_xsps x2 where x2.xsp_selected = 'Y'
--            union all select '~~~~' xsp_value from dual) xs
--        where xe.nte_ne_id_of = m.nm_ne_id_of
--          and xe.nte_job_id = m_nte_job_id
--          and m.nm_begin_mp <= xe.nte_end_mp
--          and m.nm_end_mp >= xe.nte_begin_mp
--          and (m.nm_begin_mp = m.nm_end_mp or (m.nm_begin_mp < xe.nte_end_mp and m.nm_end_mp > xe.nte_begin_mp))
--          and (xe.nte_begin_mp < xe.nte_end_mp or m.nm_begin_mp = m.nm_end_mp)
--          and m.nm_ne_id_in = i.iit_ne_id
--          and i.iit_inv_type = xt.column_value
--          and nvl(i.iit_x_sect, '~~~~') = xs.xsp_value
--        ) q
--        ,nm_inv_types t
--        where q.iit_inv_type = t.nit_inv_type
--        group by
--           t.nit_category
--          ,t.nit_inv_type
--          ,t.nit_descr;
--
--
      INSERT INTO nm0575_matching_records ( asset_category
                                          , asset_type
                                          , asset_type_descr
                                          , asset_count
                                          , asset_wholly_enclosed 
                                          , asset_partially_enclosed
                                          , asset_contiguous)
          SELECT nit_category, nm_obj_type, nit_descr, (whole+partial), whole, partial,  nit_contiguous
          FROM (
            WITH all_data AS
                   (  SELECT nm_ne_id_in
                           , nm_obj_type
                           , partial
                        FROM (
                        SELECT nm_ne_id_in
                              , nm_obj_type
                              , max(partial) partial
                                  FROM (
                                        SELECT q2.*
                                             , ROW_NUMBER ( ) OVER (PARTITION BY q2.nm_ne_id_in ORDER BY 1) iit_rownum
                                             , CASE
                                                 WHEN ( keep_begin_mp  IS NOT NULL
                                                    OR  keep_end_mp    IS NOT NULL
                                                    OR  keep_begin_mp2 IS NOT NULL
                                                    OR  keep_end_mp2   IS NOT NULL )
                                                 THEN
                                                   1
                                                 ELSE
                                                   0
                                               END partial
                                          FROM (SELECT DISTINCT
                                                       q.iit_ne_id nm_ne_id_in
                                                     , q.nm_ne_id_of
                                                     , q.nm_begin_mp
                                                     , q.nm_end_mp
                                                     , q.nm_start_date
                                                     , q.nm_admin_unit
                                                     , q.nm_type
                                                     , q.nm_obj_type
                                                     , q.nm_cardinality
                                                     , q.nm_seq_no
                                                     , q.nm_seg_no
                                                     , q.excluded_member_count
                                                     , g.iig_parent_id
                                                     , CASE WHEN q.nm_begin_mp < q.nte_begin_mp THEN q.nm_begin_mp ELSE NULL END  keep_begin_mp
                                                     , CASE WHEN q.nm_begin_mp < q.nte_begin_mp THEN q.nte_begin_mp ELSE NULL END keep_end_mp
                                                     , CASE WHEN q.nm_end_mp > q.nte_end_mp THEN q.nte_end_mp ELSE NULL END       keep_begin_mp2
                                                     , CASE WHEN q.nm_end_mp > q.nte_end_mp THEN q.nm_end_mp ELSE NULL END        keep_end_mp2
                                                  FROM (SELECT DISTINCT
                                                               m.*
                                                             , te.nte_ne_id_of
                                                             , te.nte_begin_mp
                                                             , te.nte_end_mp
                                                             , COUNT ( NVL2 ( te.nte_ne_id_of, NULL, 1 ) ) OVER (PARTITION BY m.iit_ne_id) excluded_member_count
                                                          FROM (SELECT i.iit_ne_id
                                                                     , im.nm_ne_id_of
                                                                     , im.nm_begin_mp
                                                                     , im.nm_end_mp
                                                                     , im.nm_start_date
                                                                     , im.nm_admin_unit
                                                                     , im.nm_type
                                                                     , im.nm_obj_type
                                                                     , im.nm_cardinality
                                                                     , im.nm_seq_no
                                                                     , im.nm_seg_no
                                                                  FROM (  SELECT DISTINCT m.nm_ne_id_in
                                                                            FROM nm_nw_temp_extents xe
                                                                               , nm_members m
                                                                           WHERE xe.nte_ne_id_of = m.nm_ne_id_of
                                                                             AND xe.nte_job_id = m_nte_job_id
                                                                             AND m.nm_type = 'I'
                                                                        GROUP BY m.nm_ne_id_in) em
                                                                     , nm_inv_items i
                                                                     , nm_members im
                                                                 WHERE em.nm_ne_id_in = i.iit_ne_id
                                                                   AND i.iit_ne_id = im.nm_ne_id_in
                                                                   and i.iit_inv_type in (select column_value from table(cast(get_inv_types_tbl as nm_code_tbl)))
                                                                   --and i.iit_inv_type = 'SPED'
                                                                   AND ( i.iit_x_sect IS NULL
                                                                     OR  i.iit_x_sect IN (SELECT x2.xsp_value
                                                                                            FROM nm0575_possible_xsps x2
                                                                                           WHERE x2.xsp_selected = 'Y') )) m
                                                             , (SELECT *
                                                                  FROM nm_nw_temp_extents
                                                                 WHERE nte_job_id = m_nte_job_id) te
                                                         WHERE m.nm_ne_id_of = te.nte_ne_id_of(+)
                                                           AND m.nm_begin_mp <= te.nte_end_mp(+)
                                                           AND m.nm_end_mp >= te.nte_begin_mp(+)) q
                                                     , nm_inv_item_groupings g
                                                 WHERE q.nte_ne_id_of IS NOT NULL
                                                   AND ( q.nm_begin_mp = q.nm_end_mp
                                                     OR  ( q.nm_begin_mp < q.nte_end_mp
                                                      AND q.nm_end_mp > q.nte_begin_mp ) )
                                                   AND ( q.nte_begin_mp < q.nte_end_mp
                                                     OR  q.nm_begin_mp = q.nm_end_mp )
                                                   AND q.iit_ne_id = g.iig_parent_id(+)) q2
                                                   )
                              GROUP BY nm_ne_id_in
                                     , nm_obj_type
                                     )
                    WHERE partial = CASE WHEN g_include_partial = 'N' THEN 0 ELSE partial END
                    GROUP BY nm_ne_id_in
                           , nm_obj_type
                           , partial)
            SELECT UNIQUE nm_obj_type
                        , nit_descr
                        , nit_category
                        , nit_contiguous
                        , ( SELECT COUNT ( * ) FROM all_data b
                             WHERE b.partial = 0
                               AND a.nm_obj_type = b.nm_obj_type ) whole
                        , ( SELECT COUNT ( * ) FROM all_data b
                             WHERE b.partial = 1
                               AND a.nm_obj_type = b.nm_obj_type ) partial
              FROM all_data a
                 , nm_inv_types
             WHERE nm_obj_type = nit_inv_type
            );
        nm3dbg.putln('insert nm0575_matching_records count: '||sql%rowcount);
        
        cache_results;
        
      -- assets over all network
      else
        -- todo: not implemented
        null;
        
      end if;
    -- CWS 02/02/2009 log 718014 Else section added to provide a way or returning details on all assets of the id is null
    else
     insert into nm0575_matching_records (
            asset_category
          , asset_type
          , asset_type_descr
          , asset_count
          , asset_wholly_enclosed
          , asset_partially_enclosed
          , asset_contiguous
        )
        select
           t.nit_category asset_category
          ,t.nit_inv_type asset_type
          ,t.nit_descr asset_type_descr
          ,count(*) asset_count
          ,count(*) asset_count
          ,0
          ,t.nit_contiguous
        from (
        select
        distinct i.iit_ne_id, i.iit_inv_type
        from
           nm_members m
          ,nm_inv_items i
          ,(select column_value from table(cast(get_inv_types_tbl as nm_code_tbl))) xt 
          ,(select x2.xsp_value from nm0575_possible_xsps x2 where x2.xsp_selected = 'Y'
            union all select '~~~~' xsp_value from dual) xs
        where m.nm_ne_id_in = i.iit_ne_id
          and i.iit_inv_type = xt.column_value
          and nvl(i.iit_x_sect, '~~~~') = xs.xsp_value
        ) q
        ,nm_inv_types t
        where q.iit_inv_type = t.nit_inv_type
        group by
           t.nit_category
          ,t.nit_inv_type
          ,t.nit_descr
          ,t.nit_contiguous;
        nm3dbg.putln('insert nm0575_matching_records count: '||sql%rowcount); 
  
    end if;
  
    m_xsp_changed := false;
    
  end if; -- do_query

  nm3dbg.deind;
exception
  when others then
    nm3dbg.puterr(sqlerrm||': '||g_package_name||'.do_query('
      ||', pi_source_type='||pi_source_type
      ||', pi_source_ne_id='||pi_source_ne_id
      ||', pi_begin_mp='||pi_begin_mp
      ||', pi_end_mp='||pi_end_mp
      ||', m_xsp_changed='||nm3dbg.to_char(m_xsp_changed)
      ||', m_nte_job_id='||m_nte_job_id
      ||')');
    raise;
    
END do_query;                       

--
-----------------------------------------------------------------------------
--
PROCEDURE clear_event_log IS

BEGIN
  null;
-- delete from nm0575_event_log;
-- commit;

END;
--
-----------------------------------------------------------------------------
--

-- this is called from the form's Process button
-- the table contains the asset types user has choosen for close/delete
PROCEDURE process_tab_asset_types(pi_tab_asset_types  IN nm3type.tab_varchar4
                                 ,pi_action           IN VARCHAR2
                                 ,pi_process_partial  IN VARCHAR2) IS

  
  i binary_integer;
  l_effective_date date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
  
  t_code          nm_code_tbl := new nm_code_tbl();
  t_iit_id        nm_id_tbl := new nm_id_tbl();
  t_iig_item_id   nm_id_tbl;
  t_iig_top_id    nm_id_tbl;
  
  l_main_count      pls_integer := 0;
  l_partial_count   pls_integer := 0;
  l_child_count     pls_integer := 0;
  --r_log           nm0575_event_log%rowtype;
  l_action        varchar2(20);
 


BEGIN
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
  
  -- todo: run over whole network
  
  -- open the main assets query
  -- this closes / resizes all placements (including potential child placements)
  --  (the top distinct removes duplicates caused by multiples from nm_inv_item_groupings table
  --   the disticnt below removes duplicate point items - the ones that fall on element start/end)
  -- the result excludes touching continuous itmes but includes touching point items
  -- if the temp extent is a single point, then only the points that fall onto it are processed
  --  the continuous items that run over the point are also excluded and thus not split.
  
  
  -- AE deal with whole network operations
  --
  IF m_nte_job_id IS NOT NULL
  THEN
--
    for r in (
  --
      select q2.*
            ,row_number() over (partition by q2.nm_ne_id_in order by 1) iit_rownum
          from (
          select distinct
             q.iit_ne_id nm_ne_id_in
            ,q.nm_ne_id_of
            ,q.nm_begin_mp
            ,q.nm_end_mp
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
                and i.iit_ne_id in (select id from table(cast(g_cached_results as nm_id_code_meaning_tbl)))
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
            and (q.nm_begin_mp = q.nm_end_mp or (q.nm_begin_mp < q.nte_end_mp and q.nm_end_mp > q.nte_begin_mp))
            and (q.nte_begin_mp < q.nte_end_mp or q.nm_begin_mp = q.nm_end_mp)
            and q.iit_ne_id = g.iig_parent_id (+)
            --and excluded_member_count = case when pi_process_partial = 'N' then 0 else excluded_member_count end
          ) q2
        )
    
    -- start of the main asset placements loop
    loop
      --nm_debug.debug_on;
      l_main_count := l_main_count + 1;
      nm3dbg.putln(l_main_count||'=(nm_ne_id_in='||r.nm_ne_id_in
        ||', nm_ne_id_of='||r.nm_ne_id_of
        ||', nm_begin_mp='||r.nm_begin_mp
        ||', nm_end_mp='||r.nm_end_mp
        ||', excluded_member_count='||r.excluded_member_count
        ||', iig_parent_id='||r.iig_parent_id
        ||', keep_begin_mp='||r.keep_begin_mp
        ||', keep_end_mp='||r.keep_end_mp
        ||', keep_begin_mp2='||r.keep_begin_mp2
        ||', keep_end_mp2='||r.keep_end_mp2
        ||')');

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
          
          --Log 717947:Linesh:20-Feb-2009:Start
          -- bulk collect all the child item ids
          --select g.iig_item_id, g.iig_top_id
          --bulk collect into t_iig_item_id, t_iig_top_id
          --from nm_inv_item_groupings g
          --connect by prior g.iig_item_id = g.iig_parent_id
          --start with g.iig_parent_id = r.iig_parent_id;

          SELECT  iig.iig_item_id, iig.iig_top_id
          bulk    collect into t_iig_item_id, t_iig_top_id
          FROM    nm_inv_item_groupings iig
                 ,nm_inv_items_all iit
                 ,nm_inv_type_groupings itg
          WHERE   iig.iig_item_id       = iit.iit_ne_id
          AND     iit.iit_inv_type      = itg.itg_inv_type
          AND     itg.itg_mandatory     = 'Y'                                    
          CONNECT By PRIOR iig_item_id = iig_parent_id
          START   WITH iig_parent_id   = r.iig_parent_id ;
          --Log 717947:Linesh:20-Feb-2009:End
          
          l_child_count := l_child_count + t_iig_item_id.count;
          
          
          -- close the hierarchy definitions
          if pi_action = 'C' then
            --Log 717947:Linesh:20-Feb-2009:As this now handled through API
            --forall i in 1 .. t_iig_item_id.count  
            --update nm_inv_item_groupings_all g
            --set g.iig_end_date = l_effective_date
            --where g.iig_item_id = t_iig_item_id(i)
            --and g.iig_top_id = t_iig_top_id(i)
            --and g.iig_end_date is null;
            Null ;     
          else
            forall i in 1 .. t_iig_item_id.count
            delete from nm_inv_item_groupings_all g
            where g.iig_item_id = t_iig_item_id(i)
              and g.iig_top_id = t_iig_top_id(i)
              and g.iig_end_date is null;
          
          end if;
          
          
          -- close the child placements
          if pi_action = 'C' then
            --Log 717947:Linesh:20-Feb-2009:As this now handled through API
            --forall i in 1 .. t_iig_item_id.count  
            --update nm_members_all m
            --set m.nm_end_date = l_effective_date
            --where m.nm_ne_id_in = t_iig_item_id(i)
            --and m.nm_end_date is null;
            Null ;
          else
            forall i in 1 .. t_iig_item_id.count  
            delete from nm_members_all m
            where m.nm_ne_id_in = t_iig_item_id(i)
              and m.nm_end_date is null;
          
          end if;
          
          -- close the child invitem records
          if pi_action = 'C' then
            --Log 717947:Linesh:20-Feb-2009:As this now handled through API
            --forall i in 1 .. t_iig_item_id.count
            --update nm_inv_items_all i
            --set i.iit_end_date = l_effective_date
            --where i.iit_ne_id = t_iig_item_id(i)
            --and i.iit_end_date is null;
            Null ;       
          else
            forall i in 1 .. t_iig_item_id.count  
            delete from nm_inv_items_all i
            where i.iit_ne_id = t_iig_item_id(i)
              and i.iit_end_date is null;
          
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
  ELSE
  -- CWS 15/06/09
  -- Whole network operations
    
    DECLARE --DECLARE PUT HERE FOR CONVENIENCE WILL TIDY LATER
      
      CURSOR full_net_cur IS
       SELECT iit_ne_id
             ,nm_ne_id_of 
             ,nm_ne_id_in
             ,nm_begin_mp
             ,nm_start_date
             ,nm_end_mp 
             ,nm_type
             ,nm_obj_type
             ,nm_cardinality
             ,nm_admin_unit
             ,nm_seq_no
             ,nm_seg_no
             ,iig_parent_id
        FROM nm_inv_items, nm_members, nm_inv_item_groupings
       WHERE iit_inv_type IN (SELECT COLUMN_VALUE FROM TABLE(CAST(t_code AS nm_code_tbl)))
         AND nm_ne_id_in = iit_ne_id
         AND nm_type = 'I'
         AND iit_ne_id = iig_parent_id(+)
         AND (iit_x_sect IS NULL 
          OR iit_x_sect IN (SELECT x2.xsp_value FROM nm0575_possible_xsps x2 WHERE x2.xsp_selected = 'Y'));
    --
    BEGIN 
    --
      FOR FULL_NET_REC IN FULL_NET_CUR LOOP    
        --
        -- close the current asset placement
        close_member_record (p_action         => pi_action
                            ,p_effective_date => l_effective_date
                            ,p_ne_id_in       => full_net_rec.nm_ne_id_in
                            ,p_ne_id_of       => full_net_rec.nm_ne_id_of
                            ,p_begin_mp       => full_net_rec.nm_begin_mp
                            ,p_start_date     => full_net_rec.nm_start_date
        );
        --
        -- store the parent asset id for later forall closure of the inv_items records
        t_iit_id.extend;
        t_iit_id(t_iit_id.last) := full_net_rec.iit_ne_id;
        --
        -- it is a parent asset
        IF full_net_rec.iig_parent_id is not null THEN        
        --
          SELECT  iig.iig_item_id, iig.iig_top_id
          BULK COLLECT INTO t_iig_item_id, t_iig_top_id
          FROM    nm_inv_item_groupings iig
                 ,nm_inv_items_all iit
                 ,nm_inv_type_groupings itg
          WHERE   iig.iig_item_id       = iit.iit_ne_id
          AND     iit.iit_inv_type      = itg.itg_inv_type
          AND     itg.itg_mandatory     = 'Y'                                    
          CONNECT BY PRIOR iig_item_id = iig_parent_id
          START   WITH iig_parent_id   = full_net_rec.iig_parent_id ;
        --
          l_child_count := l_child_count + t_iig_item_id.count;
        --
        -- close the hierarchy definitions
          IF pi_action <> 'C' THEN
          --
              FORALL i IN 1 .. t_iig_item_id.count
              DELETE FROM nm_inv_item_groupings_all g
              WHERE g.iig_item_id = t_iig_item_id(i)
                AND g.iig_top_id = t_iig_top_id(i)
                AND g.iig_end_date IS NULL;
            
              FORALL i in 1 .. t_iig_item_id.count  
              DELETE FROM nm_members_all m
               WHERE m.nm_ne_id_in = t_iig_item_id(i)
                 AND m.nm_end_date IS NULL;
                      
              FORALL i IN 1 .. t_iig_item_id.count  
              DELETE FROM nm_inv_items_all i
               WHERE i.iit_ne_id = t_iig_item_id(i)
                 AND i.iit_end_date IS NULL;
          --  
          END IF;
        --  
        -- close child doc assocs
          FORALL i IN 1 .. t_iig_item_id.count
          DELETE FROM doc_assocs
          WHERE das_rec_id = to_char(t_iig_item_id(i))
            AND das_table_name in ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS');            
        --  
        END IF; -- it is a parent asset                  
        -- close current record doc assocs
        DELETE FROM doc_assocs
         WHERE das_rec_id = to_char(FULL_NET_REC.iig_parent_id)
           AND das_table_name in ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS'); 
      --
      END LOOP;
      
    END; -- CWS END END OF CODE CHANGE.
    --
    nm_debug.debug('Identified '||t_iit_id.COUNT||' to delete');
    --
  END IF;
  -- close all memberless assets
  if pi_action = 'C' then
    --Log 717947:Linesh:20-Feb-2009:Start
    --added this to end the grouping records before end dating the asset
    forall i in 1 .. t_iit_id.count
    update nm_inv_item_groupings_all g
    set g.iig_end_date = l_effective_date
    where g.iig_item_id = t_iit_id(i)
    and g.iig_end_date is null ;         
    --Log 717947:Linesh:20-Feb-2009:End

    forall i in 1 .. t_iit_id.count
    update nm_inv_items_all
    set iit_end_date = l_effective_date
    where iit_ne_id = t_iit_id(i)
      and iit_end_date is null;
  
  -- delete
  elsif pi_action = 'D' then
    --nm_debug.debug_on;
    nm_debug.debug('Delete '||t_iit_id.count||' assets' );
    nm_debug.debug('Job ID '||m_nte_job_id);
    --Log 717947:Linesh:20-Feb-2009:Start
    --added this to delete the grouping records before end dating the asset
--    forall i in 1 .. t_iit_id.count
--    delete from nm_inv_item_groupings_all g
--    where g.iig_item_id = t_iit_id(i);
--    --
--    forall i in 1 .. t_iit_id.count
--    delete from nm_inv_item_groupings_all g
--    where g.iig_Parent_id = t_iit_id(i);
--    --
--    --Log 717947:Linesh:20-Feb-2009:End
--    --
    forall i in 1 .. t_iit_id.count
    delete from nm_inv_items_all
    where iit_ne_id = t_iit_id(i)
      and iit_end_date is null
      and not exists
        (select 1 from nm_members
          where iit_ne_id = nm_ne_id_in
            and nm_ne_id_in = t_iit_id(i) );
      
  end if;
  
  nm3dbg.putln('l_whole_count='||t_iit_id.count);
  nm3dbg.putln('l_partial_count='||l_partial_count);
  nm3dbg.putln('l_child_count='||l_child_count);
  
--   raise zero_divide;
 
  nm3dbg.deind;
--exception
--  when others then
--    nm3dbg.puterr(sqlerrm||': '||g_package_name||'.process_tab_asset_types('
--      ||'pi_tab_asset_types.count='||pi_tab_asset_types.count
--      ||', pi_action='||pi_action
--      ||', pi_process_partial='||pi_process_partial
--      ||', m_nte_job_id='||m_nte_job_id
--      ||')');
--    raise;
END;
--
-----------------------------------------------------------------------------
--
PROCEDURE tidy_up IS

BEGIN

  delete from nm_gaz_query_item_list
  where  ngqi_job_id = m_nte_job_id;
 
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
        and nm_end_date is null;
      if sql%rowcount = 0 then
        nm3dbg.putln('update no_data_found: close_member_record('||p_action
          ||', '||p_ne_id_in||', '||p_ne_id_of||', '||p_begin_mp||', '||p_start_date||')');
      end if;
    
    -- delete
    elsif p_action = 'D' then
    
      -- delete old member
      delete from nm_members_all
      where nm_ne_id_in = p_ne_id_in
        and nm_ne_id_of = p_ne_id_of
        and nm_begin_mp = p_begin_mp
        and nm_start_date = p_start_date
        and nm_end_date is null;
      if sql%rowcount = 0 then
        nm3dbg.putln('delete no_data_found: close_member_record('||p_action
          ||', '||p_ne_id_in||', '||p_ne_id_of||', '||p_begin_mp||', '||p_start_date||')');
      end if;
        
    end if;
  end;
  
  
  
  -- this is useful code, but not used here.
  function are_tables_equal(
     pt_1 in nm3type.tab_varchar4
    ,pt_2 in nm3type.tab_varchar4
  ) return boolean
  is
    i_count binary_integer;
  begin
    i_count := greatest(pt_1.count, pt_2.count);
    
    for i in 1 .. i_count loop
      if pt_1.exists(i) then
        if pt_2.exists(i) then
          if pt_1(i) = pt_2(i) then
            null;
          elsif pt_1(i) is null and pt_2(i) is null then
            null;
          else
            return false;
          end if;
        else
          return false;
        end if;
      elsif pt_2.exists(i) then
        return false;
      end if;
    end loop;
    
    return true;
    
  end;
  
  
  
  procedure set_xsp_changed
  is
  begin
    nm3dbg.putln(g_package_name||'.set_xsp_changed('
      ||')');
    m_xsp_changed := true;
  end;
--
-----------------------------------------------------------------------------
--
  PROCEDURE set_partial_flag ( pi_partial_flag IN VARCHAR2 )
  IS
  BEGIN
  --
    g_include_partial := pi_partial_flag;
  --
  END set_partial_flag;
--
-----------------------------------------------------------------------------
--
END nm0575;
/