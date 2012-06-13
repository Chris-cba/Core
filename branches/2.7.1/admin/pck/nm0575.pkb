CREATE OR REPLACE PACKAGE BODY nm0575
AS
--   PVCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm0575.pkb-arc   2.7.1.10   Jun 13 2012 08:30:28   Rob.Coupe  $
--       Module Name      : $Workfile:   nm0575.pkb  $
--       Date into PVCS   : $Date:   Jun 13 2012 08:30:28  $
--       Date fetched Out : $Modtime:   Jun 13 2012 08:28:54  $
--       PVCS Version     : $Revision:   2.7.1.10  $
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
  g_body_sccsid  CONSTANT varchar2(2000)  := '"$Revision:   2.7.1.10  $"';
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
--
-----------------------------------------------------------------------------
--
  procedure close_member_record(
     p_action in varchar2
    ,p_effective_date in date
    ,p_ne_id_in in id_type
    ,p_ne_id_of in id_type default null
    ,p_begin_mp in mp_type default null
    ,p_start_date in date
  );
--
  procedure close_part_member_record(
     p_action         in varchar2
    ,p_effective_date in date
    ,p_ne_id_in       in id_type
    ,p_ne_id_of       in id_type 
    ,p_begin_mp       in mp_type 
    ,p_end_mp         in mp_type    
    ,p_start_date     in date
    ,p_end_date       in date
    ,p_admin_unit     in id_type  
    ,p_obj_type       in varchar2 
    ,p_keep_begin1    in number default null
    ,p_keep_end1      in number default null
    ,p_keep_begin2    in number default null
    ,p_keep_end2      in number default null   
  );
--
-----------------------------------------------------------------------------
--
  function are_tables_equal(
     pt_1 in nm3type.tab_varchar4
    ,pt_2 in nm3type.tab_varchar4
  ) return boolean;
--
-----------------------------------------------------------------------------
--
  PROCEDURE check_no_future_locs (p_nte_job_id  nm_nw_temp_extents.nte_job_id%type
                               ,p_effective_date DATE DEFAULT nm3user.get_effective_date
                               );
--
-----------------------------------------------------------------------------
--
  PROCEDURE check_extent_no_future_locs (p_ne_id      nm_elements.ne_id%TYPE
                                        ,p_effective_date DATE DEFAULT nm3user.get_effective_date
                                        );



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
PROCEDURE delete_doc_assocs (pi_iit_ne_id IN nm_inv_items.iit_ne_id%TYPE)
IS
BEGIN
  IF pi_iit_ne_id IS NOT NULL
  THEN
    DELETE FROM doc_assocs
    WHERE das_rec_id = TO_CHAR(pi_iit_ne_id)
      AND (das_table_name IN ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS')
         OR das_table_name IN (SELECT dgs_table_syn FROM doc_gate_syns
                                WHERE dgs_dgt_table_name IN ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS')));
  END IF;
END delete_doc_assocs;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_doc_assocs (pi_tab_ids IN nm_id_tbl)
IS
BEGIN
  IF pi_tab_ids.COUNT>0 
  THEN
    FORALL i IN 1..pi_tab_ids.COUNT
      DELETE FROM doc_assocs
      WHERE das_rec_id = TO_CHAR(pi_tab_ids(i))
        AND (das_table_name IN ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS')
           OR das_table_name IN (SELECT dgs_table_syn FROM doc_gate_syns
                                  WHERE dgs_dgt_table_name IN ('NM_INV_ITEMS_ALL','NM_INV_ITEMS','INV_ITEMS_ALL','INV_ITEMS')));
  END IF;
END delete_doc_assocs;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_memberships ( pi_nm_rec IN nm_members%ROWTYPE )
IS
BEGIN 
  nm_debug.debug('# Create member : ('||pi_nm_rec.nm_ne_id_in||', '||pi_nm_rec.nm_ne_id_of||', '||pi_nm_rec.nm_begin_mp||', '||pi_nm_rec.nm_end_mp||', '||pi_nm_rec.nm_begin_mp||')');
  INSERT INTO nm_members_all VALUES pi_nm_rec; 
EXCEPTION
  WHEN DUP_VAL_ON_INDEX
  THEN
-- RAC - Task 0111930 - review failure:
-- original code would try to re-create a duplicate member by date and start measure - so the following was doen. however, similar problems in duplicating data 
--occurred for both ends and did not always violate the key- so the code was chanegd to handle the part memberships -
--  so this code should not be needed any longer but left in just in case.
-- We know a record will exist at this stage when the user has opted to close instead of delete
-- i.e. the insert on the data that is kept from an intersection 
-- at the start of the asset will always fail - the process has only just end-dated the row!
-- So we need to perform the update of the original to give a new start-measure and then re-insert the row
-- Original is commented out - it merely updated the record to provide correct information after the op
-- but lost the part that was valid in the past.
--    UPDATE nm_members_all
--       SET nm_begin_mp   = pi_nm_rec.nm_begin_mp
--         , nm_end_mp     = pi_nm_rec.nm_end_mp
--         , nm_end_date   = NULL
--     WHERE nm_ne_id_in   = pi_nm_rec.nm_ne_id_in
--       AND nm_ne_id_of   = pi_nm_rec.nm_ne_id_of
--       AND nm_begin_mp   = pi_nm_rec.nm_begin_mp
--       AND nm_start_date = pi_nm_rec.nm_start_date; 
--
    UPDATE nm_members_all
       SET nm_begin_mp   = pi_nm_rec.nm_end_mp
     WHERE nm_ne_id_in   = pi_nm_rec.nm_ne_id_in
       AND nm_ne_id_of   = pi_nm_rec.nm_ne_id_of
       AND nm_begin_mp   = pi_nm_rec.nm_begin_mp
       AND nm_start_date = pi_nm_rec.nm_start_date; 
--
  INSERT INTO nm_members_all VALUES pi_nm_rec; 
--

END create_memberships;
--
-----------------------------------------------------------------------------
--
PROCEDURE log_event(pi_log_iit_inv_type      IN nm0575_event_log.LOG_IIT_INV_TYPE%TYPE
                   ,pi_log_action            IN nm0575_event_log.log_action%TYPE
                   ,pi_log_iit_ne_id         IN nm0575_event_log.log_iit_ne_id%TYPE
                   ,pi_log_iit_primary_key   IN nm0575_event_log.log_iit_primary_key%TYPE
                   ,pi_log_iit_descr         IN nm0575_event_log.log_iit_descr%TYPE
                   ,pi_log_message           IN nm0575_event_log.log_message%TYPE
                   ,pi_log_error_flag        IN nm0575_event_log.log_error_flag%TYPE) 
IS 
  l_rec_nm0575_event_log nm0575_event_log%ROWTYPE;
BEGIN
--
  l_rec_nm0575_event_log.log_iit_ne_id := pi_log_iit_ne_id;
  l_rec_nm0575_event_log.log_iit_inv_type := pi_log_iit_inv_type;
  l_rec_nm0575_event_log.log_action := pi_log_action;
  l_rec_nm0575_event_log.log_iit_primary_key := pi_log_iit_primary_key;
  l_rec_nm0575_event_log.log_iit_descr := pi_log_iit_descr;
  l_rec_nm0575_event_log.log_message := pi_log_message;
  l_rec_nm0575_event_log.log_error_flag := pi_log_error_flag;

--
-- The log will only log the first occurence of an asset, but in the case of an error
-- the log will need to be merged with the existing record.
--
  MERGE INTO NM0575_EVENT_LOG l 
  USING (SELECT l_rec_nm0575_event_log.log_iit_ne_id
              , l_rec_nm0575_event_log.log_iit_inv_type
              , l_rec_nm0575_event_log.log_action
              , l_rec_nm0575_event_log.log_iit_primary_key
              , l_rec_nm0575_event_log.log_iit_descr
              , l_rec_nm0575_event_log.log_message
              , l_rec_nm0575_event_log.log_error_flag 
          FROM dual)
  ON (l.log_iit_ne_id = l_rec_nm0575_event_log.log_iit_ne_id)
  WHEN MATCHED THEN
     UPDATE SET log_action     = l_rec_nm0575_event_log.log_action
              , log_iit_descr  = l_rec_nm0575_event_log.log_iit_descr
              , log_message    = l_rec_nm0575_event_log.log_message
              , log_error_flag = l_rec_nm0575_event_log.log_error_flag
    WHEN NOT MATCHED THEN
       INSERT ( log_iit_inv_type
               ,log_action
               ,log_iit_ne_id
               ,log_iit_primary_key
               ,log_iit_descr
               ,log_message
               ,log_error_flag)
       VALUES ( l_rec_nm0575_event_log.log_iit_inv_type
               ,l_rec_nm0575_event_log.log_action
               ,l_rec_nm0575_event_log.log_iit_ne_id
               ,l_rec_nm0575_event_log.log_iit_primary_key
               ,l_rec_nm0575_event_log.log_iit_descr
               ,l_rec_nm0575_event_log.log_message
               ,l_rec_nm0575_event_log.log_error_flag);

END log_event; 

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
                                            OR  keep_end_mp2   IS NOT NULL 
                                            OR  excluded_member_count > 0)
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
            --WHERE partial = CASE WHEN g_include_partial = 'N' THEN 0 ELSE partial END
            GROUP BY nm_ne_id_in
                   , nm_obj_type
                   , partial
                   )
        SELECT cast ( collect (nm_id_code_meaning_type ( nm_ne_id_in, nm_obj_type, partial ) ) as  nm_id_code_meaning_tbl )
          INTO g_cached_results
          FROM all_data;
--
END cache_results;
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
--
  if pi_source_type = 'E' then
    l_nte_source := 'SAVED';
  else
    check_extent_no_future_locs( pi_source_ne_id, nm3user.get_effective_date );
    l_nte_source := 'ROUTE';
  end if;

  
  if m_xsp_changed then
--
    -- clear the previous temp extent
    if m_nte_job_id is not null then
      delete from nm_nw_temp_extents
      where nte_job_id = m_nte_job_id;
    end if;
    
    commit;
    execute immediate 'truncate table nm0575_matching_records';
    
    -- an area of interest is defined
    if pi_source_ne_id is not null then
    
--RAC - extent and dates need to be checked    
    
      nm3extent.create_temp_ne (
         pi_source_id => pi_source_ne_id
        ,pi_source    => l_nte_source
        ,pi_begin_mp  => pi_begin_mp
        ,pi_end_mp    => pi_end_mp
        ,po_job_id    => m_nte_job_id
      );
      nm3dbg.putln('m_nte_job_id='||m_nte_job_id);

      check_no_future_locs( m_nte_job_id, nm3user.get_effective_date );

      if g_tab_selected_categories.count > 0 then
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
                                                      OR  keep_end_mp2   IS NOT NULL
                                                      OR  excluded_member_count > 0 )
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
                      --WHERE partial = CASE WHEN g_include_partial = 'N' THEN 0 ELSE partial END
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
      end if;
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
--
    m_xsp_changed := false;
--
  end if; -- do_query
--
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
--
END do_query;
--
-----------------------------------------------------------------------------
--
PROCEDURE clear_event_log IS

BEGIN
  null;
END;
--
-----------------------------------------------------------------------------
--
-- this is called from the form's Process button
-- the table contains the asset types user has choosen for close/delete
PROCEDURE process_tab_asset_types(pi_tab_asset_types  IN nm3type.tab_varchar4
                                 ,pi_action           IN VARCHAR2
                                 ,pi_process_partial  IN VARCHAR2
) IS
  i                      BINARY_INTEGER;
  l_effective_date       DATE := nm3user.get_effective_date;
  t_code                 nm_code_tbl := new nm_code_tbl();
  t_iit_id               nm_id_tbl := new nm_id_tbl();
  t_iig_item_id          nm_id_tbl;
  t_iig_top_id           nm_id_tbl;
  l_main_count           PLS_INTEGER := 0;
  l_partial_count        PLS_INTEGER := 0;
  l_child_count          PLS_INTEGER := 0;
  l_log_message          nm3type.max_varchar2;
  l_action               VARCHAR2(20);
  c_end_location_only    BOOLEAN := UPPER(pi_action) = 'C';
  l_partial_message      VARCHAR2(500);
  l_doc_assocs_count     NUMBER := 0;
  l_operation            VARCHAR2(30) := CASE WHEN c_end_location_only=TRUE THEN 'End-date' ELSE 'Delete' END;
--
BEGIN
  nm3dbg.putln(g_package_name||'.process_tab_asset_types('
    ||'pi_tab_asset_types.count='||pi_tab_asset_types.count
    ||', pi_action='||pi_action
    ||', pi_process_partial='||pi_process_partial
    ||', m_nte_job_id='||m_nte_job_id
    ||')');
  nm3dbg.ind;

  -- set the inv_types to be used in the asset select

  i := pi_tab_asset_types.first;
  while i is not null loop
    t_code.extend;
    t_code(t_code.last) := pi_tab_asset_types(i);
    i := pi_tab_asset_types.next(i);
  end loop;

  nm3dbg.putln('t_code.count='||t_code.count);

  -- open the main assets query
  -- this closes / resizes all placements (including potential child placements)
  --  (the top distinct removes duplicates caused by multiples from nm_inv_item_groupings table
  --   the disticnt below removes duplicate point items - the ones that fall on element start/end)
  -- the result excludes touching continuous itmes but includes touching point items
  -- if the temp extent is a single point, then only the points that fall onto it are processed
  --  the continuous items that run over the point are also excluded and thus not split.
  --
  --nm_debug.debug_on;
  IF m_nte_job_id IS NOT NULL
  THEN
  --nm_debug.debug_on;
--
    FOR R IN (
  --
      SELECT q2.*
            ,row_number() OVER (PARTITION BY q2.nm_ne_id_in order by 1) iit_rownum
          FROM (
          SELECT DISTINCT
             q.iit_ne_id nm_ne_id_in
            ,q.iit_primary_key
            ,q.iit_descr
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
                ,i.iit_primary_key
                ,i.iit_descr
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
    LOOP
  --
      BEGIN
      --
        l_main_count := l_main_count + 1;
        nm_debug.debug('# - Asset Delete - flag = '||g_include_partial||' - loop number = '||l_main_count); 
        --
        -- The asset is wholly closed
        -- i.e. the query return all member records for the assets identified in the query.
        --  Excluded_Member_Count = number of asset locations excluded - implying this asset is partially contained within the ROI.
        --  Keep_Begin_Mp + Keep_End_Mp = first portion of a particular member that needs to be recreated.
        --  Keep_Begin_Mp2 + Keep_End_Mp2 = second portion of a particular member that needs to be recreated . 
        --  Iit_Rownum = indicates the membership record number. 
        --
        
        -- If there are no excluded members, no portions that need recreating and it's the first occurance then we can assume
        -- this record is an asset which needs to be entirely deleted/end-dated.
        IF ( r.excluded_member_count = 0 AND r.keep_begin_mp IS NULL AND r.keep_begin_mp2 IS NULL AND r.iit_rownum = 1 )
        THEN
        --
          nm_debug.debug('# - '||l_operation||' whole asset '||r.nm_ne_id_in||':'||r.nm_obj_type||' at count '||l_main_count||' - parent = '||r.iig_parent_id); 
          -- Close the member record later for any assets with a parent.
          IF r.iig_parent_id IS NULL
          THEN
            -- close the current asset placement in it's entirety
            l_partial_message := CASE WHEN pi_action = 'C' 
                                   THEN 'Closed' 
                                   ELSE 'Deleted' 
                                 END||' entirely - ';
        --
        -- Close the whole member record.
        --
            nm_debug.debug('# No parent item - '||l_operation||' the entire member for '||r.nm_ne_id_in);
            close_member_record(
               p_action         => pi_action
              ,p_effective_date => l_effective_date
              ,p_ne_id_in       => r.nm_ne_id_in
              ,p_start_date     => r.nm_start_date
            );
          END IF;
      --
        ELSE
        --
        -- Process the parts of the assets for which there are excluded members (i.e. partial inclusion within ROI).
        -- If the flag is set to include these parts, then the close_member_record procedure is called excluding the member parts.
        --
          IF r.iig_parent_id IS NULL
          THEN
            -- close the current asset placement part.
            l_partial_message := CASE WHEN pi_action = 'C' THEN 'Closed' ELSE 'Deleted' END
                                            ||CASE WHEN g_include_partial = 'Y' 
                                              THEN ' partially'
                                              ELSE ' entirely'
                                            END||' - ';
            nm_debug.debug('# No parent item - '||l_operation||' the '||
                           CASE WHEN g_include_partial = 'Y' 
                             THEN 'partial member '||r.nm_ne_id_of||' at '||r.nm_begin_mp
                             ELSE 'whole member (flag set to delete whole)'
                           END||' for '||r.nm_ne_id_in);
        --
        -- Close the member record.
        -- If the include_partial flag is Y then close the part, otherwise
        -- close the entire membership.
        --
            if g_include_partial = 'Y' and (r.keep_begin_mp is null or r.keep_begin_mp2 is null ) then  
              close_member_record(
                p_action         => pi_action
               ,p_effective_date => l_effective_date
               ,p_ne_id_in       => r.nm_ne_id_in
               ,p_ne_id_of       => CASE WHEN g_include_partial = 'Y' THEN r.nm_ne_id_of ELSE NULL END
               ,p_begin_mp       => CASE WHEN g_include_partial = 'Y' THEN r.nm_begin_mp ELSE NULL END
               ,p_start_date     => r.nm_start_date
              );
            elsif g_include_partial = 'N' then
              close_member_record(
                           p_action         => pi_action
                          ,p_effective_date => l_effective_date
                          ,p_ne_id_in       => r.nm_ne_id_in
                          ,p_start_date     => r.nm_start_date
                        );
--                      
            --
            END IF;
        --
        END IF;

        -- the asset is wholly closed
        IF ((r.excluded_member_count = 0  -- If there are no exluded members.
          AND r.keep_begin_mp IS NULL     -- No begin mp to keep.
          AND r.keep_begin_mp2 IS NULL)   -- No end mp to keep
          OR g_include_partial = 'N')     -- OR we are just deleting everything based on the flag value.
          AND r.iit_rownum = 1            -- It's the first occurence of the asset (by member)
        THEN
           -- store the parent asset id for later forall closure of the inv_items records
          t_iit_id.extend;
          t_iit_id(t_iit_id.last) := r.nm_ne_id_in;

          -- it is a parent asset
          IF r.iig_parent_id IS NOT NULL 
          THEN
            nm_debug.debug('# - '||l_operation||' hierarchical asset children '||' - '||r.nm_ne_id_in);
            SELECT iig.iig_item_id, iig.iig_top_id BULK COLLECT INTO t_iig_item_id, t_iig_top_id
              FROM nm_inv_item_groupings iig
                 , nm_inv_items_all iit
                 , nm_inv_type_groupings itg
             WHERE iig.iig_item_id       = iit.iit_ne_id
               AND iit.iit_inv_type      = itg.itg_inv_type
               AND itg.itg_mandatory     = 'Y'
           CONNECT BY PRIOR iig_item_id = iig_parent_id
             START WITH iig_parent_id   = r.iig_parent_id ;

            l_child_count := l_child_count + t_iig_item_id.COUNT;

            -- close the hierarchy definitions
            IF pi_action = 'C' 
            THEN
              --Log 717947:Linesh:20-Feb-2009:As this now handled through API
              NULL ;
            ELSE
              FORALL I IN 1 .. t_iig_item_id.COUNT
              DELETE FROM nm_inv_item_groupings_all g
              WHERE g.iig_item_id = t_iig_item_id(i)
                AND g.iig_top_id = t_iig_top_id(i);
              nm_debug.debug('# - '||l_operation||' hierarchical '||to_char(SQL%ROWCOUNT)||' asset children links');
              --  and g.iig_end_date is null;
            END IF;

            -- close the child placements
            IF pi_action = 'C' 
            THEN
              --Log 717947:Linesh:20-Feb-2009:As this now handled through API
              NULL ;
            ELSE
              FORALL i IN 1 .. t_iig_item_id.COUNT  
                DELETE FROM nm_members_all m 
                 WHERE m.nm_ne_id_in = t_iig_item_id(i);
            END IF;
            
            -- close the child invitem records
            IF pi_action = 'C' 
            THEN
              --Log 717947:Linesh:20-Feb-2009:As this now handled through API
              NULL ;
            ELSE
              FORALL i IN 1 .. t_iig_item_id.COUNT  
              DELETE FROM nm_inv_items_all i
               WHERE i.iit_ne_id = t_iig_item_id(i);
            END IF;
            
            FOR i in 1..t_iig_item_id.COUNT LOOP
              nm_debug.debug('# - Close doc assocs for Parent '||r.iig_parent_id||' of '||t_iig_item_id(i));
            END LOOP;
            -- close child doc assocs
            delete_doc_assocs(t_iig_item_id);
          --
          -- Finally close the membership for the parent assets after clearing up the children.
          --
            nm_debug.debug('# - '||l_operation||' hierarchical asset memberships '||' - '||r.nm_ne_id_in||' - Parent set to '||r.iig_parent_id);
            --RC - Ignoring partial locations of hierarchical assets (for now)
            close_member_record(
                           p_action         => pi_action
                          ,p_effective_date => l_effective_date
                          ,p_ne_id_in       => r.nm_ne_id_in
                          ,p_start_date     => r.nm_start_date
                        );
            l_partial_message := CASE WHEN pi_action = 'C' THEN 'Closed' ELSE 'Deleted' END
                               ||CASE WHEN g_include_partial = 'Y' 
                                 THEN ' partially'
                                 ELSE ' entirely'
                               END||' - ';
          END IF; -- it is a parent asset
          
          nm_debug.debug('# - Close doc assocs for Parent '||r.iig_parent_id);
          -- close current record doc assocs
          delete_doc_assocs (r.iig_parent_id);
          delete_doc_assocs (r.nm_ne_id_in);
        ELSE
          nm_debug.debug('# - '||l_operation||' partial asset memberships '||' - '||r.nm_ne_id_in||' at rownum '||r.iit_rownum);

          if g_include_partial = 'Y' then
          
            close_part_member_record( p_action         => pi_action
                                     ,p_effective_date => l_effective_date
                                     ,p_ne_id_in       => r.nm_ne_id_in
                                     ,p_ne_id_of       => r.nm_ne_id_of
                                     ,p_begin_mp       => r.nm_begin_mp
                                     ,p_end_mp         => r.nm_end_mp
                                     ,p_start_date     => r.nm_start_date
                                     ,p_end_date       => null
                                     ,p_admin_unit     => r.nm_admin_unit
                                     ,p_obj_type       => r.nm_obj_type
                                     ,p_keep_begin1    => r.keep_begin_mp
                                     ,p_keep_end1      => r.keep_end_mp
                                     ,p_keep_begin2    => r.keep_begin_mp2
                                     ,p_keep_end2      => r.keep_end_mp2 );
                                     
            l_partial_message := CASE WHEN pi_action = 'C' THEN 'Closed' ELSE 'Deleted' END
                             ||CASE WHEN g_include_partial = 'Y' 
                               THEN ' partially'
                               ELSE ' entirely'
                             END||' - ';
            l_partial_count := l_partial_count + 1;
          
          else
            -- RC - just get rid and no need to process the keep -bits.
            close_member_record(
                           p_action         => pi_action
                          ,p_effective_date => l_effective_date
                          ,p_ne_id_in       => r.nm_ne_id_in
                          ,p_start_date     => r.nm_start_date
                        );
                        
            l_partial_message := CASE WHEN pi_action = 'C' THEN 'Closed' ELSE 'Deleted' END
                               ||CASE WHEN g_include_partial = 'Y' 
                                 THEN ' partially'
                                 ELSE ' entirely'
                               END||' - ';
            
          end if;
          
        END IF; -- wholly closed asset
        
      -- Code below removed since the close_part_member_record will re-create intersecting parts
--          DECLARE
--            l_rec_nm_begin nm_members%ROWTYPE;
--            l_rec_nm_end   nm_members%ROWTYPE;
--          BEGIN
--            IF r.keep_begin_mp IS NOT NULL or r.keep_begin_mp2 IS NOT NULL 
--            THEN
--              nm_debug.debug('# - Recreate partial membership 1 '
--                            ||r.nm_ne_id_in||':'
--                            ||r.nm_ne_id_of||':'
--                            ||r.nm_obj_type||':'
--                            ||r.keep_begin_mp||':'
--                            ||r.keep_end_mp);
--              l_rec_nm_begin.nm_ne_id_in    := r.nm_ne_id_in;
--              l_rec_nm_begin.nm_ne_id_of    := r.nm_ne_id_of;
--              l_rec_nm_begin.nm_type        := r.nm_type;
--              l_rec_nm_begin.nm_obj_type    := r.nm_obj_type;
--              l_rec_nm_begin.nm_begin_mp    := r.keep_begin_mp;
--              l_rec_nm_begin.nm_start_date  := r.nm_start_date;
--              l_rec_nm_begin.nm_end_mp      := r.keep_end_mp;
--              l_rec_nm_begin.nm_admin_unit  := r.nm_admin_unit;
--              l_rec_nm_begin.nm_cardinality := r.nm_cardinality;
--              l_rec_nm_begin.nm_seq_no      := r.nm_seq_no;
--              l_rec_nm_begin.nm_seg_no      := r.nm_seg_no;
----
----           the closure of the original part members has been deferred - handle the create-memberships ans the closure in one subprogram
----
--
--              create_memberships (l_rec_nm_begin);
--            END IF;
--            IF r.keep_begin_mp2 IS NOT NULL 
--            THEN
--              nm_debug.debug('# - Recreate partial membership 2 '
--                            ||r.nm_ne_id_in||':'
--                            ||r.nm_ne_id_of||':'
--                            ||r.nm_obj_type||':'
--                            ||r.keep_begin_mp||':'
--                            ||r.keep_end_mp);
--              l_rec_nm_end.nm_ne_id_in    := r.nm_ne_id_in;
--              l_rec_nm_end.nm_ne_id_of    := r.nm_ne_id_of;
--              l_rec_nm_end.nm_type        := r.nm_type;
--              l_rec_nm_end.nm_obj_type    := r.nm_obj_type;
--              l_rec_nm_end.nm_begin_mp    := r.keep_begin_mp2;
--              l_rec_nm_end.nm_start_date  := r.nm_start_date;
--              l_rec_nm_end.nm_end_mp      := r.keep_end_mp2;
--              l_rec_nm_end.nm_admin_unit  := r.nm_admin_unit;
--              l_rec_nm_end.nm_cardinality := r.nm_cardinality;
--              l_rec_nm_end.nm_seq_no      := r.nm_seq_no;
--              l_rec_nm_end.nm_seg_no      := r.nm_seg_no;
--              create_memberships (l_rec_nm_end);
--            END IF;
--          END;
		END IF;
      --
        l_log_message := l_partial_message||g_success_message;
      --
        IF r.iit_rownum = 1
        THEN
          log_event(pi_log_iit_inv_type     => r.nm_obj_type
                   ,pi_log_action           => pi_action
                   ,pi_log_iit_ne_id        => r.nm_ne_id_in
                   ,pi_log_iit_primary_key  => r.iit_primary_key
                   ,pi_log_iit_descr        => r.iit_descr
                   ,pi_log_message          => l_log_message
                   ,pi_log_error_flag       => 'N' );
        END IF;

      EXCEPTION
        WHEN OTHERS THEN
        l_log_message := substr(SQLERRM,0,500);
        log_event(pi_log_iit_inv_type     => r.nm_obj_type
                 ,pi_log_action           => pi_action
                 ,pi_log_iit_ne_id        => r.nm_ne_id_in
                 ,pi_log_iit_primary_key  => r.iit_primary_key
                 ,pi_log_iit_descr        => r.iit_descr
                 ,pi_log_message          => l_log_message
                 ,pi_log_error_flag       => 'Y' );
      
      END;

    END LOOP;
    nm3dbg.putln('l_main_count='||l_main_count);
  ELSE
  -- CWS 15/06/09
  -- Whole network operations
    DECLARE
      CURSOR full_net_cur IS
       SELECT iit_ne_id
             ,iit_primary_key
             ,iit_descr
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
        BEGIN    
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
          IF full_net_rec.iig_parent_id is not null 
          THEN
          --
           SELECT iig.iig_item_id, iig.iig_top_id
             BULK COLLECT INTO t_iig_item_id, t_iig_top_id
             FROM nm_inv_item_groupings iig
                 ,nm_inv_items_all iit
                 ,nm_inv_type_groupings itg
            WHERE iig.iig_item_id = iit.iit_ne_id
              AND iit.iit_inv_type = itg.itg_inv_type
              AND itg.itg_mandatory = 'Y'
          CONNECT BY PRIOR iig_item_id = iig_parent_id
            START WITH iig_parent_id = full_net_rec.iig_parent_id ;
          --
            l_child_count := l_child_count + t_iig_item_id.count;
          --
          -- close the hierarchy definitions
            IF pi_action <> 'C' THEN
            --
                FORALL i IN 1 .. t_iig_item_id.count
                DELETE FROM nm_inv_item_groupings_all g
                WHERE g.iig_item_id = t_iig_item_id(i)
                  AND g.iig_top_id = t_iig_top_id(i);

                FORALL i in 1 .. t_iig_item_id.count  
                DELETE FROM nm_members_all m
                 WHERE m.nm_ne_id_in = t_iig_item_id(i);

                FORALL i IN 1 .. t_iig_item_id.count  
                DELETE FROM nm_inv_items_all i
                 WHERE i.iit_ne_id = t_iig_item_id(i);
            --  
            END IF;
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
          l_log_message := CASE WHEN pi_action = 'C' 
                             THEN 'Closed' 
                             ELSE 'Deleted' 
                           END||' entirely - '||g_success_message;
      --
          log_event(pi_log_iit_inv_type     => full_net_rec.nm_obj_type
                   ,pi_log_action           => pi_action
                   ,pi_log_iit_ne_id        => full_net_rec.nm_ne_id_in
                   ,pi_log_iit_primary_key  => full_net_rec.iit_primary_key
                   ,pi_log_iit_descr        => full_net_rec.iit_descr
                   ,pi_log_message          => l_log_message
                   ,pi_log_error_flag       => 'N' );

        EXCEPTION
          WHEN OTHERS 
          THEN
          l_log_message := substr(SQLERRM,0,500);
          log_event(pi_log_iit_inv_type     => full_net_rec.nm_obj_type
                   ,pi_log_action           => pi_action
                   ,pi_log_iit_ne_id        => full_net_rec.nm_ne_id_in
                   ,pi_log_iit_primary_key  => full_net_rec.iit_primary_key
                   ,pi_log_iit_descr        => full_net_rec.iit_descr
                   ,pi_log_message          => l_log_message
                   ,pi_log_error_flag       => 'Y' );
        END;
      --
      END LOOP;
    --
    END;
    --
    nm_debug.debug('Identified '||t_iit_id.COUNT||' to delete');
    --
  END IF;
  -- close all memberless assets
  IF pi_action = 'C' 
  THEN
--
    FORALL i IN 1 .. t_iit_id.COUNT
    UPDATE nm_inv_item_groupings_all g
       SET g.iig_end_date = l_effective_date
     WHERE g.iig_item_id = t_iit_id (i);
--
    FORALL i IN 1 .. t_iit_id.COUNT
    UPDATE nm_inv_items_all
       SET iit_end_date = l_effective_date
     WHERE iit_ne_id = t_iit_id (i);
--
  ELSIF pi_action = 'D' THEN
--
    FORALL i IN 1 .. t_iit_id.COUNT
    DELETE FROM nm_inv_item_groupings_all
     WHERE iig_item_id  = t_iit_id (i);
--
    FORALL i IN 1 .. t_iit_id.COUNT
    DELETE FROM nm_inv_items_all
      WHERE iit_ne_id = t_iit_id (i)
        AND NOT EXISTS
              (SELECT 1
                 FROM nm_members_all
                WHERE iit_ne_id = nm_ne_id_in AND nm_ne_id_in = t_iit_id (i));
--
  END IF;
--
END;
--
-----------------------------------------------------------------------------
--
  PROCEDURE tidy_up IS
  BEGIN
    DELETE nm_gaz_query_item_list WHERE ngqi_job_id = m_nte_job_id;
    mt_inv_categories := NULL;
    mt_inv_types      := NULL;
    m_nte_job_id      := NULL;
   COMMIT;
  END tidy_up;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_inv_categories_tbl RETURN nm_code_tbl
  IS
    l_count PLS_INTEGER;
  BEGIN
    l_count := mt_inv_categories.COUNT;
    RETURN mt_inv_categories;
  EXCEPTION
    WHEN collection_is_null THEN
      mt_inv_categories := NEW nm_code_tbl();
      RETURN mt_inv_categories;
  END;
--
-----------------------------------------------------------------------------
--
  FUNCTION get_inv_types_tbl RETURN nm_code_tbl
  IS
    l_count PLS_INTEGER;
  BEGIN
    l_count := mt_inv_types.COUNT;
    RETURN mt_inv_types;
  EXCEPTION
    WHEN COLLECTION_IS_NULL THEN
      mt_inv_types := NEW nm_code_tbl();
      RETURN mt_inv_types;
  END;
--
-----------------------------------------------------------------------------
--
  -- this sets the mt_inv_types and also populates the mt_child_types
  PROCEDURE set_inv_types_tbl(p_tbl in nm_code_tbl)
  IS
  BEGIN
    mt_inv_types := p_tbl;
  END;
--
-----------------------------------------------------------------------------
--
  PROCEDURE close_member_record(
     p_action         IN VARCHAR2
    ,p_effective_date IN DATE
    ,p_ne_id_in       IN id_type
    ,p_ne_id_of       IN id_type DEFAULT NULL
    ,p_begin_mp       IN mp_type DEFAULT NULL
    ,p_start_date     IN DATE
  )
  IS
  BEGIN
    nm_debug.debug('# Close member : ('||p_action||', '||p_ne_id_in||', '||p_ne_id_of||', '||p_begin_mp||', '||p_start_date||')');
    -- end date
    IF p_action = 'C' 
    THEN
      UPDATE nm_members
      SET nm_end_date = p_effective_date
      WHERE nm_ne_id_in = p_ne_id_in
        AND nm_ne_id_of = NVL(p_ne_id_of,nm_ne_id_of)
        AND nm_begin_mp = NVL(p_begin_mp,nm_begin_mp)
        AND nm_start_date = decode( p_ne_id_of, null, nm_start_date, p_start_date)
        and nm_end_date is null;
--RC> Re-instated the end-date predicate and changed the operand to members rather than members-all.
--    The code uses an effective date which, if in the past could allow closure on an already closed member. This is almost certainly
--    going to throw date-tracking errors.	
      IF SQL%ROWCOUNT = 0 THEN
        nm3dbg.putln('update no_data_found: close_member_record('||p_action
          ||', '||p_ne_id_in||', '||p_ne_id_of||', '||p_begin_mp||', '||p_start_date||')');
      END IF;
    -- delete
    ELSIF p_action = 'D' 
    THEN
      -- delete old member
      DELETE FROM nm_members_all
      WHERE nm_ne_id_in = p_ne_id_in
        AND nm_ne_id_of = NVL(p_ne_id_of,nm_ne_id_of)
        AND nm_begin_mp = NVL(p_begin_mp,nm_begin_mp)
        AND nm_start_date = decode( p_ne_id_of, null, nm_start_date, p_start_date);
        -- Allow to operate on any effective date
        --and nm_end_date is null;
      IF SQL%ROWCOUNT = 0 
      THEN
        nm3dbg.putln('delete no_data_found: close_member_record('||p_action
          ||', '||p_ne_id_in||', '||p_ne_id_of||', '||p_begin_mp||', '||p_start_date||')');
      END IF;
    END IF;
  END;
--
  procedure close_part_member_record(
     p_action         in varchar2
    ,p_effective_date in date
    ,p_ne_id_in       in id_type
    ,p_ne_id_of       in id_type
    ,p_begin_mp       in mp_type
    ,p_end_mp         in mp_type 
    ,p_start_date     in date
    ,p_end_date       in date
    ,p_admin_unit     in id_type
    ,p_obj_type       in varchar2
    ,p_keep_begin1    in number default null
    ,p_keep_end1      in number default null
    ,p_keep_begin2    in number default null
    ,p_keep_end2      in number default null   
  ) IS
  l_rec1 nm_members_all%rowtype; -- := nm3get.get_nm_all(p_ne_id_in,p_ne_id_of,p_begin_mp,p_start_date,false);
  l_rec2 nm_members_all%rowtype;
  BEGIN
  
    l_rec1.nm_ne_id_in    := p_ne_id_in;
    l_rec1.nm_ne_id_of    := p_ne_id_of;
    l_rec1.nm_begin_mp    := p_begin_mp;
    l_rec1.nm_end_mp      := p_end_mp;
    l_rec1.nm_start_date  := p_start_date;
    l_rec1.nm_end_date    := p_end_date;
    l_rec1.nm_admin_unit  := p_admin_unit;
    l_rec1.nm_obj_type    := p_obj_type;
    l_rec1.nm_type        := 'I';
    
    if g_include_partial = 'Y' then
    IF p_keep_begin1 is null and
       p_keep_end1   is null and
       p_keep_begin2 is null and
       p_keep_end2   is null then
--     this should not have been called, just use the standard close member procedure
      close_member_record( p_action         => p_action
                          ,p_effective_date => p_effective_date
                          ,p_ne_id_in       => p_ne_id_in
                          ,p_ne_id_of       => p_ne_id_of
                          ,p_begin_mp       => p_begin_mp
                          ,p_start_date     => p_start_date );
    ELSIF p_keep_begin1 is not null and 
          p_keep_end1   is not null and
          p_keep_begin2 is null and
          p_keep_end2   is null then
--          
--     need to retain part 1 - needs to be split into two chunks on part 1 alone
      if p_keep_end1 < p_begin_mp  or p_keep_begin1 > p_end_mp then
--      no intersection, just end-dae original
        close_member_record( p_action         => p_action
                           ,p_effective_date => p_effective_date
                           ,p_ne_id_in       => p_ne_id_in
                           ,p_ne_id_of       => p_ne_id_of
                           ,p_begin_mp       => p_begin_mp
                           ,p_start_date     => p_start_date );
      END IF;
--
      l_rec2 := l_rec1;

      if p_keep_begin1 > l_rec1.nm_begin_mp then
        l_rec1.nm_end_mp := p_keep_begin1;
      end if;
      
      if p_keep_end1 < l_rec1.nm_end_mp then
        l_rec1.nm_begin_mp := p_keep_end1;
      end if;
      
      if p_action = 'C' then
        update nm_members_all
        set nm_begin_mp = l_rec1.nm_begin_mp,
            nm_end_mp   = l_rec1.nm_end_mp
        where nm_ne_id_in = p_ne_id_in
        and   nm_ne_id_of = p_ne_id_of
        and   nm_begin_mp = p_begin_mp
        and   nm_start_date = p_start_date;
      else
        close_member_record( p_action         => p_action
                            ,p_effective_date => p_effective_date
                            ,p_ne_id_in       => p_ne_id_in
                            ,p_ne_id_of       => p_ne_id_of
                            ,p_begin_mp       => p_begin_mp
                            ,p_start_date     => p_start_date );
      end if;              
      
      l_rec2.nm_begin_mp := p_keep_begin1;
      l_rec2.nm_end_mp   := p_keep_end1;
      l_rec2.nm_end_date := null;
      
      nm3ins.ins_nm(l_rec2);
--
    ELSIF p_keep_begin1 is null and 
          p_keep_end1   is null and
          p_keep_begin2 is not null and
          p_keep_end2   is not null then
--
--   need to retain part 2 - needs to be split into two chunks on part 2 alone
      IF p_keep_end2 < p_begin_mp  or p_keep_begin2 > p_end_mp then
--     no intersection, just end-dae original
       close_member_record( p_action         => p_action
                           ,p_effective_date => p_effective_date
                           ,p_ne_id_in       => p_ne_id_in
                           ,p_ne_id_of       => p_ne_id_of
                           ,p_begin_mp       => p_begin_mp
                           ,p_start_date     => p_start_date );
      END IF;
--
      l_rec2 := l_rec1;

      if p_keep_begin2 > l_rec1.nm_begin_mp then
        l_rec1.nm_end_mp := p_keep_begin2;
      end if;
      
      if p_keep_end2 < l_rec1.nm_end_mp then
        l_rec1.nm_begin_mp := p_keep_end2;
      end if;

      if p_action = 'C' then
      
        update nm_members_all
        set nm_begin_mp = l_rec1.nm_begin_mp,
            nm_end_mp   = l_rec1.nm_end_mp
        where nm_ne_id_in = p_ne_id_in
        and   nm_ne_id_of = p_ne_id_of
        and   nm_begin_mp = p_begin_mp
        and   nm_start_date = p_start_date;
      else
      
        close_member_record( p_action         => p_action
                            ,p_effective_date => p_effective_date
                            ,p_ne_id_in       => p_ne_id_in
                            ,p_ne_id_of       => p_ne_id_of
                            ,p_begin_mp       => p_begin_mp
                            ,p_start_date     => p_start_date );
      
      end if;
      
      l_rec2.nm_begin_mp := p_keep_begin2;
      l_rec2.nm_end_mp   := p_keep_end2;
      l_rec2.nm_end_date := null;
      
      nm3ins.ins_nm(l_rec2);
           
    ELSIF p_keep_begin1 is not null and 
          p_keep_end1   is not null and
          p_keep_begin2 is not null and
          p_keep_end2   is not null then
--    need to retain parts 1 and 2 - needs to be split into three chunks.              
      l_rec2 := l_rec1;
      l_rec1.nm_begin_mp := least(p_keep_end1, p_keep_end2);
      l_rec1.nm_end_mp   := greatest(p_keep_begin1, p_keep_begin2);
--
      if p_action = 'C' then
      
        update nm_members_all
        set nm_begin_mp = l_rec1.nm_begin_mp,
            nm_end_mp   = l_rec1.nm_end_mp,
            nm_end_date = p_effective_date
        where nm_ne_id_in = p_ne_id_in
        and   nm_ne_id_of = p_ne_id_of
        and   nm_begin_mp = p_begin_mp
        and   nm_start_date = p_start_date;
        
      else
      
        close_member_record( p_action         => p_action
                            ,p_effective_date => p_effective_date
                            ,p_ne_id_in       => p_ne_id_in
                            ,p_ne_id_of       => p_ne_id_of
                            ,p_begin_mp       => p_begin_mp
                            ,p_start_date     => p_start_date );
      
      end if;

      l_rec2.nm_begin_mp := p_keep_begin1;
      l_rec2.nm_end_mp   := p_keep_end1;
      l_rec2.nm_end_date := null;

      nm3ins.ins_nm(l_rec2);
                  
      l_rec2.nm_begin_mp := p_keep_begin2;
      l_rec2.nm_end_mp   := p_keep_end2;
      l_rec2.nm_end_date := null;

      nm3ins.ins_nm(l_rec2);

    ELSE
       raise_application_error( -20001, 'Incorrect combination of measure values 1='||p_keep_begin1||',2='||p_keep_end1||',3='||p_keep_begin2||',4='||p_keep_end2);
    END IF;
    else
      -- just in case -operate on all the members 
      close_member_record( p_action         => p_action
                          ,p_effective_date => p_effective_date
                          ,p_ne_id_in       => p_ne_id_in
                          ,p_start_date     => p_start_date );
    end if; -- g_include_partial
  END;  
  

-----------------------------------------------------------------------------
--
  -- this is useful code, but not used here.
  FUNCTION are_tables_equal(
     pt_1 in nm3type.tab_varchar4
    ,pt_2 in nm3type.tab_varchar4
  ) RETURN BOOLEAN
  IS
    i_count BINARY_INTEGER;
  BEGIN
    i_count := GREATEST(pt_1.COUNT, pt_2.COUNT);
    FOR i IN 1 .. i_count LOOP
      if pt_1.EXISTS(i) THEN
        if pt_2.EXISTS(i) THEN
          IF pt_1(i) = pt_2(i) THEN
            NULL;
          ELSIF pt_1(i) IS NULL AND pt_2(i) IS NULL THEN
            NULL;
          ELSE
            RETURN FALSE;
          END IF;
        ELSE
          RETURN FALSE;
        END IF;
      ELSIF pt_2.EXISTS(I) THEN
        RETURN FALSE;
      END IF;
    END LOOP;
    RETURN TRUE;
  END;
--
-----------------------------------------------------------------------------
--
  PROCEDURE set_xsp_changed
  IS
  BEGIN
    nm3dbg.putln(g_package_name||'.set_xsp_changed('||')');
    m_xsp_changed := TRUE;
  END;
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
PROCEDURE check_extent_no_future_locs (p_ne_id      nm_elements.ne_id%TYPE
                                      ,p_effective_date DATE DEFAULT nm3user.get_effective_date
                                      ) IS
--
--If we are to operate on a route at a specific date, the delete global asset list will leave assets of the specific type that exist
--on datums that were not part of the route on the date in question and will be left unaffected. We need to fail if a route is used at a 
--date that includes datum members that start after the effective date.
--
   CURSOR cs_future_locs (c_nm_ne_id_in    nm_members_all.nm_ne_id_in%TYPE
                         ,c_effective_date DATE
                         ) IS
   SELECT 1 from dual where exists (
       select 1 from  nm_members_all nm
   WHERE  nm_ne_id_in   = c_nm_ne_id_in
    AND   nm_start_date > c_effective_date );
--
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'check_extent_no_future_locs');
--
   OPEN  cs_future_locs (p_ne_id, p_effective_date);
   FETCH cs_future_locs INTO l_dummy;
   l_found := cs_future_locs%FOUND;
   CLOSE cs_future_locs;
--
   IF l_found
    THEN
      raise_application_error( -20001, 'The NW has datums that start later than the effective date - the assets on this member datum would either be unaffected or '||
                                       ' give rise to a server error');
--      hig.raise_ner (pi_appl => nm3type.c_net
--                    ,pi_id   => 355
--                    );
   END IF;
--
   nm_debug.proc_end (g_package_name,'check_extent_no_future_locs');
--
END check_extent_no_future_locs;


PROCEDURE check_no_future_locs (p_nte_job_id  nm_nw_temp_extents.nte_job_id%type
                               ,p_effective_date DATE DEFAULT nm3user.get_effective_date
                               ) IS
--
--If we are to operate on an extent (which may be an extent formed from a route on a specific date), there may be 
--visible asset locations that have been end-dated at a datelater than the effective date (ie already closed). These records really should not be touched.
--Better to have a module which end-dates all at a specific date and deletes anything that was created after that date.
--
   CURSOR cs_future_locs (c_job_id  nm_nw_temp_extents.nte_job_id%type
                         ,c_effective_date DATE
                         ) IS
   SELECT 1 from dual where exists (
       select 1 from  nm_members_all nm, nm_nw_temp_extents
   WHERE  nm_ne_id_of   = nte_ne_id_of
   and    nm_type = 'I'
   and    nm_obj_type in (select nit_inv_type from nm_inv_types t
                          where t.nit_category in (select column_value from table(cast(get_inv_categories_tbl as nm_code_tbl))))
   AND   (nm_start_date > c_effective_date OR  -- this record is invisible to the query of items
          nm_end_date   > c_effective_date ));   -- these have already been updated to a date greater than the proposed end-date.
--
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'check_no_future_locs');
--
   OPEN  cs_future_locs (p_nte_job_id, p_effective_date);
   FETCH cs_future_locs INTO l_dummy;
   l_found := cs_future_locs%FOUND;
   CLOSE cs_future_locs;
--
   IF l_found
    THEN
      raise_application_error( -20001, 'Inv. data that is opened later than the effective date will remain unaffected or data that has been closed later '|| 
                                       'than this date will be changed');
--      hig.raise_ner (pi_appl => nm3type.c_net
--                    ,pi_id   => 355
--                    );
   END IF;
--
   nm_debug.proc_end (g_package_name,'check_no_future_locs');
--
END check_no_future_locs;

  
--
-----------------------------------------------------------------------------
--
END nm0575;
/
