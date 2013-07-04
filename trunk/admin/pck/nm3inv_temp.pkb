CREATE OR REPLACE PACKAGE BODY nm3inv_temp AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_temp.pkb-arc   2.3   Jul 04 2013 16:08:48   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3inv_temp.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:08:48  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:14  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.9
-------------------------------------------------------------------------
--
--   Author : Kevin Angus
--
--   nm3inv_temp body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.3  $';
  g_package_name CONSTANT varchar2(30) := 'nm3inv_temp';
--
   g_tab_vc_copy_item     nm3type.tab_varchar32767;
   g_tab_vc_check_rec_tii nm3type.tab_varchar32767;
   g_tab_vc_copy_back_inv nm3type.tab_varchar32767;
   g_tab_vc_copy_inv      nm3type.tab_varchar32767;
   g_tab_compare_sql      nm3type.tab_varchar32767;
--
   g_last_copy_children   boolean;
--
   CURSOR cs_cols (c_table    varchar2
                  ,c_not_col1 varchar2 DEFAULT NULL
                  ,c_not_col2 varchar2 DEFAULT NULL
                  ,c_not_col3 varchar2 DEFAULT NULL
                  ) IS
   SELECT column_name
    FROM  all_tab_columns
   WHERE  owner        = Sys_Context('NM3CORE','APPLICATION_OWNER')
    AND   table_name   = c_table
    AND   column_name != NVL(c_not_col1,nm3type.c_nvl)
    AND   column_name != NVL(c_not_col2,nm3type.c_nvl)
    AND   column_name != NVL(c_not_col3,nm3type.c_nvl);
--
   c_tii         CONSTANT varchar2(30) := 'NM_TEMP_INV_ITEMS';
   c_til         CONSTANT varchar2(30) := 'NM_TEMP_INV_ITEMS_LIST';
   c_new_ne_id   CONSTANT varchar2(30) := 'TII_NE_ID_NEW';
   c_tii_ne_id   CONSTANT varchar2(30) := 'TII_NE_ID';
   c_iit_ne_id   CONSTANT varchar2(30) := 'IIT_NE_ID';
   c_primary_key CONSTANT varchar2(30) := 'TII_PRIMARY_KEY';
   c_foreign_key CONSTANT varchar2(30) := 'IIT_FOREIGN_KEY';
   c_iit         CONSTANT varchar2(30) := 'NM_INV_ITEMS';
   c_iit_all     CONSTANT varchar2(30) := 'NM_INV_ITEMS_ALL';
--
--
-----------------------------------------------------------------------------
--
PROCEDURE split_up_temp_data (pi_njo_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE make_new (p_njc_job_id nm_temp_inv_members.tim_njc_job_id%TYPE
                   ,p_begin_mp   number
                   ,p_end_mp     number
                   );
--
-----------------------------------------------------------------------------
--
PROCEDURE build_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE split_each_rec_tim (p_begin_mp IN     number
                             ,p_end_mp   IN     number
                             ,p_rec_tim  IN     nm_temp_inv_members%ROWTYPE
                             );
--
-----------------------------------------------------------------------------
--
PROCEDURE build_check_rec_tii_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE reassemble_chunks (p_njc_job_id nm_temp_inv_members.tim_njc_job_id%TYPE);
--
-----------------------------------------------------------------------------
--
PROCEDURE reassemble_individual (p_njc_job_id      nm_temp_inv_members.tim_njc_job_id%TYPE
                                ,p_extent_begin_mp nm_temp_inv_members.tim_extent_begin_mp%TYPE
                                ,p_extent_end_mp   nm_temp_inv_members.tim_extent_end_mp%TYPE
                                );
--
-----------------------------------------------------------------------------
--
PROCEDURE build_copy_back_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_copy_sql (pi_include_children boolean);
--
-----------------------------------------------------------------------------
--
FUNCTION temp_locations_are_coincident
                        (pi_job_id      nm_temp_inv_items.tii_njc_job_id%TYPE
                        ,pi_ne_id_old_1 nm_temp_inv_items.tii_ne_id%TYPE
                        ,pi_ne_id_new_1 nm_temp_inv_items.tii_ne_id_new%TYPE
                        ,pi_ne_id_old_2 nm_temp_inv_items.tii_ne_id%TYPE
                        ,pi_ne_id_new_2 nm_temp_inv_items.tii_ne_id_new%TYPE
                        ) RETURN boolean;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_compare_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_tim (pi_rec_tim nm_temp_inv_members%ROWTYPE,p_level pls_integer DEFAULT 3);
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
PROCEDURE delete_copy (pi_njc_job_id IN nm_job_control.njc_job_id%TYPE
                      ) IS
BEGIN
--
  nm_debug.proc_start(g_package_name,'delete_copy');
--
  DELETE nm_temp_inv_items
  WHERE  tii_njc_job_id = pi_njc_job_id;
--
  DELETE nm_temp_inv_items_list
  WHERE  til_njc_job_id = pi_njc_job_id;
--
  nm_debug.proc_end(g_package_name,'delete_copy');
--
END delete_copy;
--
-----------------------------------------------------------------------------
--
PROCEDURE make_copy(pi_njc_job_id       IN nm_job_control.njc_job_id%TYPE
                   ,pi_nte_job_id       IN nm_nw_temp_extents.nte_job_id%TYPE
                   ,pi_inv_type         IN nm_inv_types.nit_inv_type%TYPE
                   ,pi_include_children IN boolean DEFAULT FALSE
                   ,pi_effective_date   IN date    DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                   ) IS
--
   c_init_eff_date  CONSTANT date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
   l_pl_arr nm_placement_array := nm3pla.initialise_placement_array;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'make_copy');
--
   nm3user.set_effective_date(p_date => pi_effective_date);
--
   IF nm3invval.inv_type_is_child_type (pi_inv_type)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 268
                    ,pi_supplementary_info => pi_inv_type
                    );
   END IF;
--
   IF   pi_include_children
    AND NOT nm3invval.all_children_are_mandatory_at (pi_inv_type)
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 269
                    ,pi_supplementary_info => pi_inv_type
                    );
   END IF;
--
   l_pl_arr := nm3pla.defrag_placement_array(nm3pla.get_placement_from_temp_ne (pi_nte_job_id));
--
   IF nm3pla.count_pl_arr_connected_chunks (l_pl_arr) != 1
    THEN
      hig.raise_ner (nm3type.c_net,81);
   END IF;
--
   ----------------------------------
   --remove any existing data for job
   ----------------------------------
   delete_copy(pi_njc_job_id => pi_njc_job_id);
--
   ------------------------------------------
   --ensure inv is split at extent boundaries
   ------------------------------------------
   
   --KA v1.9. Added this as we are not modifying any attributes or network
   --coverage so we can skip various checks
   nm3merge.set_nw_operation_in_progress;
   
   nm3inv_update.date_tracked(pi_inv_type       => pi_inv_type
                             ,pi_roi_nte_id     => pi_nte_job_id
                             ,pi_effective_date => pi_effective_date
                             );
                             
   --KA v1.9.
   nm3merge.set_nw_operation_in_progress(FALSE);
--
  -----------
  --get items
  -----------
   build_copy_sql (pi_include_children);
   g_tii_njc_job_id    := pi_njc_job_id;
   g_nte_job_id        := pi_nte_job_id;
   g_inv_type          := pi_inv_type;
--   nm3ddl.debug_tab_varchar(g_tab_vc_copy_inv);
   nm3ddl.execute_tab_varchar(g_tab_vc_copy_inv);
--
   -------------
   --get members
   -------------

   INSERT INTO nm_temp_inv_members
         (tim_njc_job_id
         ,tim_ne_id_in
         ,tim_ne_id_of
         ,tim_type
         ,tim_obj_type
         ,tim_start_date
         ,tim_end_date
         ,tim_slk
         ,tim_cardinality
         ,tim_admin_unit
         ,tim_seq_no
         ,tim_seg_no
         ,tim_true
         ,tim_extent_begin_mp
         ,tim_extent_end_mp
         )
   SELECT *
    FROM (SELECT /*+ INDEX (nm nm_pk) */
                 pi_njc_job_id
                ,nm.nm_ne_id_in
                ,nm.nm_ne_id_of
                ,nm.nm_type
                ,nm.nm_obj_type
                ,nm.nm_start_date
                ,nm.nm_end_date
                ,nm.nm_slk
                ,nm.nm_cardinality
                ,nm.nm_admin_unit
                ,nm.nm_seq_no
                ,nm.nm_seg_no
                ,nm.nm_true
                ,nm3pla.get_measure_in_pl_arr(l_pl_arr,nm_lref(nm.nm_ne_id_of,nm.nm_begin_mp)) tim_extent_begin_mp
                ,nm3pla.get_measure_in_pl_arr(l_pl_arr,nm_lref(nm.nm_ne_id_of,nm.nm_end_mp))   tim_extent_end_mp
           FROM  nm_members        nm
                ,nm_temp_inv_items tii
          WHERE  tii.tii_njc_job_id = pi_njc_job_id
           AND   tii.tii_ne_id      = nm.nm_ne_id_in
         )
   WHERE tim_extent_begin_mp IS NOT NULL  -- Remove these ones as they are what gaz query has brought back
    AND  tim_extent_end_mp   IS NOT NULL; -- as adjoining the region of interest. these are the ones we've just split out!
--
   -- get rid of those records without locations (i.e. the adjoining items) from the list
   DELETE FROM nm_temp_inv_items_list
   WHERE  NOT EXISTS (SELECT 1
                       FROM  nm_temp_inv_members
                      WHERE  til_njc_job_id = tim_njc_job_id
                       AND   til_iit_ne_id  = tim_ne_id_in
                     );
--
   DELETE FROM nm_temp_inv_items
   WHERE  NOT EXISTS (SELECT 1
                       FROM  nm_temp_inv_members
                      WHERE  tii_njc_job_id = tim_njc_job_id
                       AND   tii_ne_id      = tim_ne_id_in
                     );
--
   split_up_temp_data (pi_njc_job_id);
--
   nm3user.set_effective_date(p_date => c_init_eff_date);
   --KA v1.9.
   nm3merge.set_nw_operation_in_progress(FALSE);
--
   nm_debug.proc_end(g_package_name,'make_copy');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date(p_date => c_init_eff_date);
      --KA v1.9.
      nm3merge.set_nw_operation_in_progress(FALSE);
      RAISE;
--
END make_copy;
--
-----------------------------------------------------------------------------
--
PROCEDURE split_up_temp_data (pi_njo_njc_job_id IN nm_job_operations.njo_njc_job_id%TYPE) IS
--
   CURSOR cs_inv_loc (c_njo_njc_job_id nm_job_operations.njo_njc_job_id%TYPE) IS
   SELECT tim_extent_begin_mp
    FROM  nm_temp_inv_members
   WHERE  tim_njc_job_id   = c_njo_njc_job_id
    AND   tim_ne_id_in_new = -1
   UNION
   SELECT tim_extent_end_mp
    FROM  nm_temp_inv_members
   WHERE  tim_njc_job_id   = c_njo_njc_job_id
    AND   tim_ne_id_in_new = -1;
--
   l_tab_mp nm3type.tab_number;
--
   l_previous number;
   l_current  number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'split_up_temp_data');
--
   OPEN  cs_inv_loc (pi_njo_njc_job_id);
   FETCH cs_inv_loc BULK COLLECT INTO l_tab_mp;
   CLOSE cs_inv_loc;
--
   build_sql;
--
   IF l_tab_mp.COUNT != 0
    THEN
      l_previous := l_tab_mp(1);
      FOR i IN 2..l_tab_mp.COUNT
       LOOP
         l_current  := l_tab_mp(i);
         make_new (p_njc_job_id => pi_njo_njc_job_id
                  ,p_begin_mp   => l_previous
                  ,p_end_mp     => l_current
                  );
         l_previous := l_current;
      END LOOP;
   END IF;
--
   DELETE FROM nm_temp_inv_items
   WHERE  tii_njc_job_id = pi_njo_njc_job_id
    AND   tii_ne_id_new  = -1;
--
   nm_debug.proc_end(g_package_name,'split_up_temp_data');
--
END split_up_temp_data;
--
-----------------------------------------------------------------------------
--
PROCEDURE make_new (p_njc_job_id nm_temp_inv_members.tim_njc_job_id%TYPE
                   ,p_begin_mp   number
                   ,p_end_mp     number
                   ) IS
--
   CURSOR cs_get_all_orig IS
   SELECT tim_ne_id_in
    FROM  nm_temp_inv_members
   WHERE  tim_njc_job_id       = p_njc_job_id
    AND   tim_ne_id_in_new     = g_old_tii_ne_id_new
    AND   tim_extent_begin_mp <= p_end_mp
    AND   tim_extent_end_mp   >= p_begin_mp
    AND   tim_extent_end_mp   != p_begin_mp
    AND   tim_extent_begin_mp != p_end_mp
   GROUP BY tim_ne_id_in;
--
   l_tab_iit_ne_id nm3type.tab_number;
   l_ne_id_new  number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'make_new');
--   nm_debug.debug(p_begin_mp||'->'||p_end_mp);
--
   g_tii_njc_job_id    := p_njc_job_id;
   g_old_tii_ne_id_new := -1;
--
   OPEN  cs_get_all_orig;
   FETCH cs_get_all_orig BULK COLLECT INTO l_tab_iit_ne_id;
   CLOSE cs_get_all_orig;
--   nm_debug.debug('Count '||l_tab_iit_ne_id.COUNT);
--
   FOR i IN 1..l_tab_iit_ne_id.COUNT
    LOOP
--      nm_debug.debug(l_tab_iit_ne_id(i));
      g_tii_ne_id         := l_tab_iit_ne_id(i);
      g_ne_id_new         := nm3net.get_next_ne_id;
      nm3ddl.execute_tab_varchar (g_tab_vc_copy_item);
      l_ne_id_new         := g_ne_id_new;
      INSERT INTO nm_temp_inv_members
            (tim_njc_job_id
            ,tim_ne_id_in
            ,tim_ne_id_in_new
            ,tim_ne_id_of
            ,tim_type
            ,tim_obj_type
            ,tim_start_date
            ,tim_end_date
            ,tim_slk
            ,tim_cardinality
            ,tim_admin_unit
            ,tim_seq_no
            ,tim_seg_no
            ,tim_true
            ,tim_extent_begin_mp
            ,tim_extent_end_mp
            )
      SELECT tim_njc_job_id
            ,tim_ne_id_in
            ,l_ne_id_new
            ,tim_ne_id_of
            ,tim_type
            ,tim_obj_type
            ,tim_start_date
            ,tim_end_date
            ,tim_slk + (p_begin_mp-tim_extent_begin_mp)
            ,tim_cardinality
            ,tim_admin_unit
            ,tim_seq_no
            ,tim_seg_no
            ,tim_true + (p_begin_mp-tim_extent_begin_mp)
            ,p_begin_mp
            ,p_end_mp
       FROM  nm_temp_inv_members
      WHERE  tim_njc_job_id       = p_njc_job_id
       AND   tim_ne_id_in         = l_tab_iit_ne_id(i)
       AND   tim_ne_id_in_new     = g_old_tii_ne_id_new
       AND   tim_extent_begin_mp <= p_end_mp
       AND   tim_extent_end_mp   >= p_begin_mp
       AND   tim_extent_end_mp   != p_begin_mp
       AND   tim_extent_begin_mp != p_end_mp;
      --
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'make_new');
--
END make_new;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_sql IS
--
   l_tab_cols nm3type.tab_varchar30;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_sql');
--
   OPEN  cs_cols (c_tii, c_new_ne_id,c_primary_key);
   FETCH cs_cols BULK COLLECT INTO l_tab_cols;
   CLOSE cs_cols;
--
   g_tab_vc_copy_item.DELETE;
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'DECLARE',FALSE);
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'   c_ne_id_new CONSTANT '||c_tii||'.'||c_new_ne_id||'%TYPE := '||g_package_name||'.g_ne_id_new;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'BEGIN');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'  INSERT INTO '||c_tii);
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'        ('||c_new_ne_id);
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'        ,'||c_primary_key);
   FOR i IN 1..l_tab_cols.COUNT
    LOOP
      nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'        ,'||l_tab_cols(i));
   END LOOP;
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'      )');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'  SELECT c_ne_id_new');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'        ,c_ne_id_new');
   FOR i IN 1..l_tab_cols.COUNT
    LOOP
      nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'        ,'||l_tab_cols(i));
   END LOOP;
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'   FROM  '||c_tii);
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'  WHERE  tii_njc_job_id = '||g_package_name||'.g_tii_njc_job_id');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'   AND   tii_ne_id      = '||g_package_name||'.g_tii_ne_id');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'   AND   tii_ne_id_new  = '||g_package_name||'.g_old_tii_ne_id_new;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_item,'END;');
--
   nm_debug.proc_end(g_package_name,'build_sql');
--
END build_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE split_temp_inv_for_measure (p_njc_job_id nm_temp_inv_members.tim_njc_job_id%TYPE
                                     ,p_begin_mp   number
                                     ,p_end_mp     number
                                     ) IS
--
   CURSOR cs_inv_here (c_njc_job_id   nm_temp_inv_members.tim_njc_job_id%TYPE
                      ,c_begin_mp     number
                      ,c_end_mp       number
                      ) IS
   SELECT *
    FROM  nm_temp_inv_members
   WHERE  tim_njc_job_id      = c_njc_job_id
    AND   tim_extent_begin_mp < c_end_mp
    AND   tim_extent_end_mp   > c_begin_mp;
--
   l_tab_rec_tim tab_rec_tim;
   l_tim_count   pls_integer := 0;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'split_temp_inv_for_measure');
--
   build_sql;
--
   FOR cs_rec IN cs_inv_here (p_njc_job_id,p_begin_mp,p_end_mp)
    LOOP
      l_tim_count                := l_tim_count + 1;
      l_tab_rec_tim(l_tim_count) := cs_rec;
   END LOOP;
--
   FOR i IN 1..l_tim_count
    LOOP
      split_each_rec_tim (p_begin_mp,p_end_mp,l_tab_rec_tim(i));
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'split_temp_inv_for_measure');
--
END split_temp_inv_for_measure;
--
-----------------------------------------------------------------------------
--
PROCEDURE split_each_rec_tim (p_begin_mp IN     number
                             ,p_end_mp   IN     number
                             ,p_rec_tim  IN     nm_temp_inv_members%ROWTYPE
                             ) IS
--
   l_need_before boolean;
   l_need_after  boolean;
--
   l_rec_tim     nm_temp_inv_members%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'split_each_rec_tim');
--
   l_need_before := (p_rec_tim.tim_extent_begin_mp < p_begin_mp);
   l_need_after  := (p_rec_tim.tim_extent_end_mp   > p_end_mp);
--
   g_tii_njc_job_id    := p_rec_tim.tim_njc_job_id;
   g_old_tii_ne_id_new := p_rec_tim.tim_ne_id_in_new;
   g_tii_ne_id         := p_rec_tim.tim_ne_id_in;
--
   IF l_need_before
    THEN
      g_ne_id_new                   := nm3net.get_next_ne_id;
      nm3ddl.execute_tab_varchar (g_tab_vc_copy_item);
      l_rec_tim                     := p_rec_tim;
      l_rec_tim.tim_ne_id_in_new    := g_ne_id_new;
      l_rec_tim.tim_extent_end_mp   := p_begin_mp;
      ins_tim (l_rec_tim);
   END IF;
   --
   IF  l_need_before
    OR l_need_after
    THEN
      -- If this item previously overlapped the passed measures
      --  then we'll need to tweak it's information
      del_tim (pi_tim_njc_job_id      => p_rec_tim.tim_njc_job_id
              ,pi_tim_ne_id_in        => p_rec_tim.tim_ne_id_in
              ,pi_tim_ne_id_in_new    => p_rec_tim.tim_ne_id_in_new
              ,pi_tim_ne_id_of        => p_rec_tim.tim_ne_id_of
              ,pi_tim_extent_begin_mp => p_rec_tim.tim_extent_begin_mp
              );
      l_rec_tim                        := p_rec_tim;
      l_rec_tim.tim_extent_begin_mp    := GREATEST(l_rec_tim.tim_extent_begin_mp,p_begin_mp);
      l_rec_tim.tim_extent_end_mp      := LEAST(l_rec_tim.tim_extent_end_mp,p_end_mp);
      ins_tim (l_rec_tim);
   END IF;
--
   IF l_need_after
    THEN
      g_ne_id_new                   := nm3net.get_next_ne_id;
      nm3ddl.execute_tab_varchar (g_tab_vc_copy_item);
      l_rec_tim                     := p_rec_tim;
      l_rec_tim.tim_ne_id_in_new    := g_ne_id_new;
      l_rec_tim.tim_extent_begin_mp := p_end_mp;
      ins_tim (l_rec_tim);
   END IF;
--
   nm_debug.proc_end(g_package_name,'split_each_rec_tim');
--
END split_each_rec_tim;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_tim (p_rec_tim nm_temp_inv_members%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_tim');
--
   INSERT INTO nm_temp_inv_members
          (tim_njc_job_id
          ,tim_ne_id_in
          ,tim_ne_id_in_new
          ,tim_ne_id_of
          ,tim_type
          ,tim_obj_type
          ,tim_start_date
          ,tim_end_date
          ,tim_slk
          ,tim_cardinality
          ,tim_admin_unit
          ,tim_date_created
          ,tim_date_modified
          ,tim_modified_by
          ,tim_created_by
          ,tim_seq_no
          ,tim_seg_no
          ,tim_true
          ,tim_extent_begin_mp
          ,tim_extent_end_mp
          )
   VALUES (p_rec_tim.tim_njc_job_id
          ,p_rec_tim.tim_ne_id_in
          ,p_rec_tim.tim_ne_id_in_new
          ,p_rec_tim.tim_ne_id_of
          ,p_rec_tim.tim_type
          ,p_rec_tim.tim_obj_type
          ,p_rec_tim.tim_start_date
          ,p_rec_tim.tim_end_date
          ,p_rec_tim.tim_slk
          ,p_rec_tim.tim_cardinality
          ,p_rec_tim.tim_admin_unit
          ,p_rec_tim.tim_date_created
          ,p_rec_tim.tim_date_modified
          ,p_rec_tim.tim_modified_by
          ,p_rec_tim.tim_created_by
          ,p_rec_tim.tim_seq_no
          ,p_rec_tim.tim_seg_no
          ,p_rec_tim.tim_true
          ,p_rec_tim.tim_extent_begin_mp
          ,p_rec_tim.tim_extent_end_mp
          );
--
   nm_debug.proc_end(g_package_name,'ins_tim');
--
END ins_tim;
--
-----------------------------------------------------------------------------
--
PROCEDURE del_tim (pi_tim_njc_job_id      nm_temp_inv_members.tim_njc_job_id%TYPE
                  ,pi_tim_ne_id_in        nm_temp_inv_members.tim_ne_id_in%TYPE
                  ,pi_tim_ne_id_in_new    nm_temp_inv_members.tim_ne_id_in_new%TYPE
                  ,pi_tim_ne_id_of        nm_temp_inv_members.tim_ne_id_of%TYPE
                  ,pi_tim_extent_begin_mp nm_temp_inv_members.tim_extent_begin_mp%TYPE
                  ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'del_tim');
--
   DELETE nm_temp_inv_members
   WHERE  tim_njc_job_id      = pi_tim_njc_job_id
    AND   tim_ne_id_in        = pi_tim_ne_id_in
    AND   tim_ne_id_in_new    = pi_tim_ne_id_in_new
    AND   tim_ne_id_of        = pi_tim_ne_id_of
    AND   tim_extent_begin_mp = pi_tim_extent_begin_mp;
--
   nm_debug.proc_end(g_package_name,'del_tim');
--
END del_tim;
--
-----------------------------------------------------------------------------
--
PROCEDURE ins_tii (p_rec_tii nm_temp_inv_items%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'ins_tii');
--
   INSERT INTO nm_temp_inv_items
          (tii_njc_job_id
          ,tii_ne_id
          ,tii_ne_id_new
          ,tii_inv_type
          ,tii_primary_key
          ,tii_primary_key_orig
          ,tii_start_date
          ,tii_date_created
          ,tii_date_modified
          ,tii_created_by
          ,tii_modified_by
          ,tii_admin_unit
          ,tii_descr
          ,tii_end_date
          ,tii_foreign_key
          ,tii_located_by
          ,tii_position
          ,tii_x_coord
          ,tii_y_coord
          ,tii_num_attrib16
          ,tii_num_attrib17
          ,tii_num_attrib18
          ,tii_num_attrib19
          ,tii_num_attrib20
          ,tii_num_attrib21
          ,tii_num_attrib22
          ,tii_num_attrib23
          ,tii_num_attrib24
          ,tii_num_attrib25
          ,tii_chr_attrib26
          ,tii_chr_attrib27
          ,tii_chr_attrib28
          ,tii_chr_attrib29
          ,tii_chr_attrib30
          ,tii_chr_attrib31
          ,tii_chr_attrib32
          ,tii_chr_attrib33
          ,tii_chr_attrib34
          ,tii_chr_attrib35
          ,tii_chr_attrib36
          ,tii_chr_attrib37
          ,tii_chr_attrib38
          ,tii_chr_attrib39
          ,tii_chr_attrib40
          ,tii_chr_attrib41
          ,tii_chr_attrib42
          ,tii_chr_attrib43
          ,tii_chr_attrib44
          ,tii_chr_attrib45
          ,tii_chr_attrib46
          ,tii_chr_attrib47
          ,tii_chr_attrib48
          ,tii_chr_attrib49
          ,tii_chr_attrib50
          ,tii_chr_attrib51
          ,tii_chr_attrib52
          ,tii_chr_attrib53
          ,tii_chr_attrib54
          ,tii_chr_attrib55
          ,tii_chr_attrib56
          ,tii_chr_attrib57
          ,tii_chr_attrib58
          ,tii_chr_attrib59
          ,tii_chr_attrib60
          ,tii_chr_attrib61
          ,tii_chr_attrib62
          ,tii_chr_attrib63
          ,tii_chr_attrib64
          ,tii_chr_attrib65
          ,tii_chr_attrib66
          ,tii_chr_attrib67
          ,tii_chr_attrib68
          ,tii_chr_attrib69
          ,tii_chr_attrib70
          ,tii_chr_attrib71
          ,tii_chr_attrib72
          ,tii_chr_attrib73
          ,tii_chr_attrib74
          ,tii_chr_attrib75
          ,tii_num_attrib76
          ,tii_num_attrib77
          ,tii_num_attrib78
          ,tii_num_attrib79
          ,tii_num_attrib80
          ,tii_num_attrib81
          ,tii_num_attrib82
          ,tii_num_attrib83
          ,tii_num_attrib84
          ,tii_num_attrib85
          ,tii_date_attrib86
          ,tii_date_attrib87
          ,tii_date_attrib88
          ,tii_date_attrib89
          ,tii_date_attrib90
          ,tii_date_attrib91
          ,tii_date_attrib92
          ,tii_date_attrib93
          ,tii_date_attrib94
          ,tii_date_attrib95
          ,tii_angle
          ,tii_angle_txt
          ,tii_class
          ,tii_class_txt
          ,tii_colour
          ,tii_colour_txt
          ,tii_coord_flag
          ,tii_description
          ,tii_diagram
          ,tii_distance
          ,tii_end_chain
          ,tii_gap
          ,tii_height
          ,tii_height_2
          ,tii_id_code
          ,tii_instal_date
          ,tii_invent_date
          ,tii_inv_ownership
          ,tii_itemcode
          ,tii_lco_lamp_config_id
          ,tii_length
          ,tii_material
          ,tii_material_txt
          ,tii_method
          ,tii_method_txt
          ,tii_note
          ,tii_no_of_units
          ,tii_options
          ,tii_options_txt
          ,tii_oun_org_id_elec_board
          ,tii_owner
          ,tii_owner_txt
          ,tii_peo_invent_by_id
          ,tii_photo
          ,tii_power
          ,tii_prov_flag
          ,tii_rev_by
          ,tii_rev_date
          ,tii_type
          ,tii_type_txt
          ,tii_width
          ,tii_xtra_char_1
          ,tii_xtra_date_1
          ,tii_xtra_domain_1
          ,tii_xtra_domain_txt_1
          ,tii_xtra_number_1
          ,tii_x_sect
          ,tii_det_xsp
          ,tii_offset
          ,tii_x
          ,tii_y
          ,tii_z
          ,tii_num_attrib96
          ,tii_num_attrib97
          ,tii_num_attrib98
          ,tii_num_attrib99
          ,tii_num_attrib100
          ,tii_num_attrib101
          ,tii_num_attrib102
          ,tii_num_attrib103
          ,tii_num_attrib104
          ,tii_num_attrib105
          ,tii_num_attrib106
          ,tii_num_attrib107
          ,tii_num_attrib108
          ,tii_num_attrib109
          ,tii_num_attrib110
          ,tii_num_attrib111
          ,tii_num_attrib112
          ,tii_num_attrib113
          ,tii_num_attrib114
          ,tii_num_attrib115
          )
   VALUES (p_rec_tii.tii_njc_job_id
          ,p_rec_tii.tii_ne_id
          ,p_rec_tii.tii_ne_id_new
          ,p_rec_tii.tii_inv_type
          ,p_rec_tii.tii_primary_key
          ,p_rec_tii.tii_primary_key_orig
          ,p_rec_tii.tii_start_date
          ,p_rec_tii.tii_date_created
          ,p_rec_tii.tii_date_modified
          ,p_rec_tii.tii_created_by
          ,p_rec_tii.tii_modified_by
          ,p_rec_tii.tii_admin_unit
          ,p_rec_tii.tii_descr
          ,p_rec_tii.tii_end_date
          ,p_rec_tii.tii_foreign_key
          ,p_rec_tii.tii_located_by
          ,p_rec_tii.tii_position
          ,p_rec_tii.tii_x_coord
          ,p_rec_tii.tii_y_coord
          ,p_rec_tii.tii_num_attrib16
          ,p_rec_tii.tii_num_attrib17
          ,p_rec_tii.tii_num_attrib18
          ,p_rec_tii.tii_num_attrib19
          ,p_rec_tii.tii_num_attrib20
          ,p_rec_tii.tii_num_attrib21
          ,p_rec_tii.tii_num_attrib22
          ,p_rec_tii.tii_num_attrib23
          ,p_rec_tii.tii_num_attrib24
          ,p_rec_tii.tii_num_attrib25
          ,p_rec_tii.tii_chr_attrib26
          ,p_rec_tii.tii_chr_attrib27
          ,p_rec_tii.tii_chr_attrib28
          ,p_rec_tii.tii_chr_attrib29
          ,p_rec_tii.tii_chr_attrib30
          ,p_rec_tii.tii_chr_attrib31
          ,p_rec_tii.tii_chr_attrib32
          ,p_rec_tii.tii_chr_attrib33
          ,p_rec_tii.tii_chr_attrib34
          ,p_rec_tii.tii_chr_attrib35
          ,p_rec_tii.tii_chr_attrib36
          ,p_rec_tii.tii_chr_attrib37
          ,p_rec_tii.tii_chr_attrib38
          ,p_rec_tii.tii_chr_attrib39
          ,p_rec_tii.tii_chr_attrib40
          ,p_rec_tii.tii_chr_attrib41
          ,p_rec_tii.tii_chr_attrib42
          ,p_rec_tii.tii_chr_attrib43
          ,p_rec_tii.tii_chr_attrib44
          ,p_rec_tii.tii_chr_attrib45
          ,p_rec_tii.tii_chr_attrib46
          ,p_rec_tii.tii_chr_attrib47
          ,p_rec_tii.tii_chr_attrib48
          ,p_rec_tii.tii_chr_attrib49
          ,p_rec_tii.tii_chr_attrib50
          ,p_rec_tii.tii_chr_attrib51
          ,p_rec_tii.tii_chr_attrib52
          ,p_rec_tii.tii_chr_attrib53
          ,p_rec_tii.tii_chr_attrib54
          ,p_rec_tii.tii_chr_attrib55
          ,p_rec_tii.tii_chr_attrib56
          ,p_rec_tii.tii_chr_attrib57
          ,p_rec_tii.tii_chr_attrib58
          ,p_rec_tii.tii_chr_attrib59
          ,p_rec_tii.tii_chr_attrib60
          ,p_rec_tii.tii_chr_attrib61
          ,p_rec_tii.tii_chr_attrib62
          ,p_rec_tii.tii_chr_attrib63
          ,p_rec_tii.tii_chr_attrib64
          ,p_rec_tii.tii_chr_attrib65
          ,p_rec_tii.tii_chr_attrib66
          ,p_rec_tii.tii_chr_attrib67
          ,p_rec_tii.tii_chr_attrib68
          ,p_rec_tii.tii_chr_attrib69
          ,p_rec_tii.tii_chr_attrib70
          ,p_rec_tii.tii_chr_attrib71
          ,p_rec_tii.tii_chr_attrib72
          ,p_rec_tii.tii_chr_attrib73
          ,p_rec_tii.tii_chr_attrib74
          ,p_rec_tii.tii_chr_attrib75
          ,p_rec_tii.tii_num_attrib76
          ,p_rec_tii.tii_num_attrib77
          ,p_rec_tii.tii_num_attrib78
          ,p_rec_tii.tii_num_attrib79
          ,p_rec_tii.tii_num_attrib80
          ,p_rec_tii.tii_num_attrib81
          ,p_rec_tii.tii_num_attrib82
          ,p_rec_tii.tii_num_attrib83
          ,p_rec_tii.tii_num_attrib84
          ,p_rec_tii.tii_num_attrib85
          ,p_rec_tii.tii_date_attrib86
          ,p_rec_tii.tii_date_attrib87
          ,p_rec_tii.tii_date_attrib88
          ,p_rec_tii.tii_date_attrib89
          ,p_rec_tii.tii_date_attrib90
          ,p_rec_tii.tii_date_attrib91
          ,p_rec_tii.tii_date_attrib92
          ,p_rec_tii.tii_date_attrib93
          ,p_rec_tii.tii_date_attrib94
          ,p_rec_tii.tii_date_attrib95
          ,p_rec_tii.tii_angle
          ,p_rec_tii.tii_angle_txt
          ,p_rec_tii.tii_class
          ,p_rec_tii.tii_class_txt
          ,p_rec_tii.tii_colour
          ,p_rec_tii.tii_colour_txt
          ,p_rec_tii.tii_coord_flag
          ,p_rec_tii.tii_description
          ,p_rec_tii.tii_diagram
          ,p_rec_tii.tii_distance
          ,p_rec_tii.tii_end_chain
          ,p_rec_tii.tii_gap
          ,p_rec_tii.tii_height
          ,p_rec_tii.tii_height_2
          ,p_rec_tii.tii_id_code
          ,p_rec_tii.tii_instal_date
          ,p_rec_tii.tii_invent_date
          ,p_rec_tii.tii_inv_ownership
          ,p_rec_tii.tii_itemcode
          ,p_rec_tii.tii_lco_lamp_config_id
          ,p_rec_tii.tii_length
          ,p_rec_tii.tii_material
          ,p_rec_tii.tii_material_txt
          ,p_rec_tii.tii_method
          ,p_rec_tii.tii_method_txt
          ,p_rec_tii.tii_note
          ,p_rec_tii.tii_no_of_units
          ,p_rec_tii.tii_options
          ,p_rec_tii.tii_options_txt
          ,p_rec_tii.tii_oun_org_id_elec_board
          ,p_rec_tii.tii_owner
          ,p_rec_tii.tii_owner_txt
          ,p_rec_tii.tii_peo_invent_by_id
          ,p_rec_tii.tii_photo
          ,p_rec_tii.tii_power
          ,p_rec_tii.tii_prov_flag
          ,p_rec_tii.tii_rev_by
          ,p_rec_tii.tii_rev_date
          ,p_rec_tii.tii_type
          ,p_rec_tii.tii_type_txt
          ,p_rec_tii.tii_width
          ,p_rec_tii.tii_xtra_char_1
          ,p_rec_tii.tii_xtra_date_1
          ,p_rec_tii.tii_xtra_domain_1
          ,p_rec_tii.tii_xtra_domain_txt_1
          ,p_rec_tii.tii_xtra_number_1
          ,p_rec_tii.tii_x_sect
          ,p_rec_tii.tii_det_xsp
          ,p_rec_tii.tii_offset
          ,p_rec_tii.tii_x
          ,p_rec_tii.tii_y
          ,p_rec_tii.tii_z
          ,p_rec_tii.tii_num_attrib96
          ,p_rec_tii.tii_num_attrib97
          ,p_rec_tii.tii_num_attrib98
          ,p_rec_tii.tii_num_attrib99
          ,p_rec_tii.tii_num_attrib100
          ,p_rec_tii.tii_num_attrib101
          ,p_rec_tii.tii_num_attrib102
          ,p_rec_tii.tii_num_attrib103
          ,p_rec_tii.tii_num_attrib104
          ,p_rec_tii.tii_num_attrib105
          ,p_rec_tii.tii_num_attrib106
          ,p_rec_tii.tii_num_attrib107
          ,p_rec_tii.tii_num_attrib108
          ,p_rec_tii.tii_num_attrib109
          ,p_rec_tii.tii_num_attrib110
          ,p_rec_tii.tii_num_attrib111
          ,p_rec_tii.tii_num_attrib112
          ,p_rec_tii.tii_num_attrib113
          ,p_rec_tii.tii_num_attrib114
          ,p_rec_tii.tii_num_attrib115
          );
--
   nm_debug.proc_end(g_package_name,'ins_tii');
--
END ins_tii;
--
-----------------------------------------------------------------------------
--
FUNCTION get_all_tim_within_ext_limits
                 (p_tim_njc_job_id      nm_temp_inv_members.tim_njc_job_id%TYPE
                 ,p_tim_extent_begin_mp nm_temp_inv_members.tim_extent_begin_mp%TYPE
                 ,p_tim_extent_end_mp   nm_temp_inv_members.tim_extent_begin_mp%TYPE
                 ,p_inv_type            nm_temp_inv_members.tim_obj_type%TYPE
                 ) RETURN tab_rec_tim IS
--
   CURSOR cs_tim (c_tim_njc_job_id      nm_temp_inv_members.tim_njc_job_id%TYPE
                 ,c_tim_extent_begin_mp nm_temp_inv_members.tim_extent_begin_mp%TYPE
                 ,c_tim_extent_end_mp   nm_temp_inv_members.tim_extent_begin_mp%TYPE
                 ,c_inv_type            nm_temp_inv_members.tim_obj_type%TYPE
                 ) IS
   SELECT *
    FROM  nm_temp_inv_members
   WHERE  tim_njc_job_id       = c_tim_njc_job_id
    AND   c_tim_extent_end_mp  > tim_extent_begin_mp
    AND   tim_extent_end_mp    > c_tim_extent_begin_mp
    AND   tim_type             = 'I'
    AND   tim_obj_type         = NVL(c_inv_type,tim_obj_type)
   ORDER BY tim_extent_begin_mp;
--
   l_retval tab_rec_tim;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_all_tim_within_ext_limits');
--
   FOR cs_rec IN cs_tim (p_tim_njc_job_id
                        ,p_tim_extent_begin_mp
                        ,p_tim_extent_end_mp
                        ,p_inv_type
                        )
    LOOP
      l_retval(cs_tim%rowcount) := cs_rec;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_all_tim_within_ext_limits');
--
   RETURN l_retval;
--
END get_all_tim_within_ext_limits;
--
-----------------------------------------------------------------------------
--
FUNCTION get_all_tim_temp_in_ext_limits
                 (p_tim_njc_job_id      nm_temp_inv_members.tim_njc_job_id%TYPE
                 ,p_tim_extent_begin_mp nm_temp_inv_members.tim_extent_begin_mp%TYPE
                 ,p_tim_extent_end_mp   nm_temp_inv_members.tim_extent_begin_mp%TYPE
                 ,p_inv_type            nm_temp_inv_members.tim_obj_type%TYPE
                 ) RETURN tab_rec_tim_temp IS
--
   CURSOR cs_tim (c_tim_njc_job_id      nm_temp_inv_members.tim_njc_job_id%TYPE
                 ,c_tim_extent_begin_mp nm_temp_inv_members.tim_extent_begin_mp%TYPE
                 ,c_tim_extent_end_mp   nm_temp_inv_members.tim_extent_begin_mp%TYPE
                 ,c_inv_type            nm_temp_inv_members.tim_obj_type%TYPE
                 ) IS
   SELECT *
    FROM  nm_temp_inv_members_temp
   WHERE  tim_njc_job_id       = c_tim_njc_job_id
    AND   c_tim_extent_end_mp  > tim_extent_begin_mp
    AND   tim_extent_end_mp    > c_tim_extent_begin_mp
    AND   tim_type             = 'I'
    AND   tim_obj_type         = c_inv_type
   ORDER BY tim_extent_begin_mp;
--
   l_retval tab_rec_tim_temp;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_all_tim_temp_in_ext_limits');
--
   FOR cs_rec IN cs_tim (p_tim_njc_job_id
                        ,p_tim_extent_begin_mp
                        ,p_tim_extent_end_mp
                        ,p_inv_type
                        )
    LOOP
      l_retval(cs_tim%rowcount) := cs_rec;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_all_tim_temp_in_ext_limits');
--
   RETURN l_retval;
--
END get_all_tim_temp_in_ext_limits;
--
-----------------------------------------------------------------------------
--
FUNCTION are_2_rec_tii_identical (p_rec_tii_1 nm_temp_inv_items%ROWTYPE
                                 ,p_rec_tii_2 nm_temp_inv_items%ROWTYPE
                                 ) RETURN boolean IS
--
   c_rec_tii_1 CONSTANT nm_temp_inv_items%ROWTYPE := g_rec_tii_1;
   c_rec_tii_2 CONSTANT nm_temp_inv_items%ROWTYPE := g_rec_tii_2;
   c_boolean   CONSTANT boolean                   := g_boolean;
--
   l_retval             boolean;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'are_2_rec_tii_identical');
--
   IF g_tab_vc_check_rec_tii.COUNT = 0
    THEN
      build_check_rec_tii_sql;
   END IF;
--
   g_rec_tii_1 := p_rec_tii_1;
   g_rec_tii_2 := p_rec_tii_2;
   nm3ddl.execute_tab_varchar(g_tab_vc_check_rec_tii);
   l_retval    := g_boolean;
   --
   -- Restore the initial values back into the globals
   --
   g_rec_tii_1 := c_rec_tii_1;
   g_rec_tii_2 := c_rec_tii_2;
   g_boolean   := c_boolean;
--
   nm_debug.proc_end(g_package_name,'are_2_rec_tii_identical');
--
   RETURN l_retval;
--
END are_2_rec_tii_identical;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_check_rec_tii_sql IS
--
   l_start    varchar2(20);
   l_tab_cols nm3type.tab_varchar30;
   l_max_len  pls_integer := 0;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_check_rec_tii_sql');
--
   g_tab_vc_check_rec_tii.DELETE;
--
   OPEN  cs_cols (c_tii, c_new_ne_id,c_primary_key,c_tii_ne_id);
   FETCH cs_cols BULK COLLECT INTO l_tab_cols;
   CLOSE cs_cols;
--
   nm3ddl.append_tab_varchar(g_tab_vc_check_rec_tii,'DECLARE',FALSE);
   nm3ddl.append_tab_varchar(g_tab_vc_check_rec_tii,'   c_rec_tii_1 CONSTANT nm_temp_inv_items%ROWTYPE := '||g_package_name||'.g_rec_tii_1;');
   nm3ddl.append_tab_varchar(g_tab_vc_check_rec_tii,'   c_rec_tii_2 CONSTANT nm_temp_inv_items%ROWTYPE := '||g_package_name||'.g_rec_tii_2;');
   nm3ddl.append_tab_varchar(g_tab_vc_check_rec_tii,'BEGIN');
   nm3ddl.append_tab_varchar(g_tab_vc_check_rec_tii,'   '||g_package_name||'.g_boolean :=');
   --
   FOR i IN 1..l_tab_cols.COUNT
    LOOP
      IF l_max_len <  LENGTH(l_tab_cols(i))
       THEN
         l_max_len := LENGTH(l_tab_cols(i));
      END IF;
   END LOOP;
   --
   l_start := '     ';
   FOR i IN 1..l_tab_cols.COUNT
    LOOP
      l_tab_cols(i) := RPAD(LOWER(l_tab_cols(i)),l_max_len,' ');
      nm3ddl.append_tab_varchar(g_tab_vc_check_rec_tii,'   '||l_start||'(c_rec_tii_1.'||l_tab_cols(i)||' = c_rec_tii_2.'||l_tab_cols(i));
      nm3ddl.append_tab_varchar(g_tab_vc_check_rec_tii,' OR (c_rec_tii_1.'||l_tab_cols(i)||' IS NULL AND c_rec_tii_2.'||l_tab_cols(i)||' IS NULL))',FALSE);
      l_start := ' AND ';
   END LOOP;
   nm3ddl.append_tab_varchar(g_tab_vc_check_rec_tii,';',FALSE);
   nm3ddl.append_tab_varchar(g_tab_vc_check_rec_tii,'END;');
--
   nm_debug.proc_end(g_package_name,'build_check_rec_tii_sql');
--
END build_check_rec_tii_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE reassemble_chunks (p_njc_job_id nm_temp_inv_members.tim_njc_job_id%TYPE) IS
--
   CURSOR cs_tim_chunks (c_njc_job_id nm_temp_inv_members.tim_njc_job_id%TYPE
                        ) IS
   SELECT tim_extent_begin_mp
         ,tim_extent_end_mp
    FROM  nm_temp_inv_members
   WHERE  tim_njc_job_id = c_njc_job_id
   GROUP BY tim_extent_begin_mp
           ,tim_extent_end_mp;
--
   l_tab_extent_begin_mp nm3type.tab_number;
   l_tab_extent_end_mp   nm3type.tab_number;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'reassemble_chunks');
--
   OPEN  cs_tim_chunks (p_njc_job_id);
   FETCH cs_tim_chunks BULK COLLECT INTO l_tab_extent_begin_mp, l_tab_extent_end_mp;
   CLOSE cs_tim_chunks;
--
   FOR i IN 1..l_tab_extent_begin_mp.COUNT
    LOOP
      reassemble_individual (p_njc_job_id      => p_njc_job_id
                            ,p_extent_begin_mp => l_tab_extent_begin_mp(i)
                            ,p_extent_end_mp   => l_tab_extent_end_mp(i)
                            );
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'reassemble_chunks');
--
END reassemble_chunks;
--
-----------------------------------------------------------------------------
--
PROCEDURE reassemble_individual (p_njc_job_id      nm_temp_inv_members.tim_njc_job_id%TYPE
                                ,p_extent_begin_mp nm_temp_inv_members.tim_extent_begin_mp%TYPE
                                ,p_extent_end_mp   nm_temp_inv_members.tim_extent_end_mp%TYPE
                                ) IS
--
   CURSOR cs_tim (c_tim_njc_job_id      nm_temp_inv_members.tim_njc_job_id%TYPE
                 ,c_tim_ne_id_in        nm_temp_inv_members.tim_ne_id_in%TYPE
                 ,c_tim_extent_begin_mp nm_temp_inv_members.tim_extent_begin_mp%TYPE
                 ) IS
   SELECT *
    FROM  nm_temp_inv_members
   WHERE  tim_njc_job_id      = c_tim_njc_job_id
    AND   tim_ne_id_in        = c_tim_ne_id_in
    AND   tim_extent_begin_mp > c_tim_extent_begin_mp
   ORDER BY tim_extent_begin_mp;
--
   l_tab_rec_tim            tab_rec_tim;
   l_tab_rec_tim_poss_match tab_rec_tim;
--
   l_last_rec_tim           nm_temp_inv_members%ROWTYPE;
   l_rec_tim                nm_temp_inv_members%ROWTYPE;
   l_rec_tim_check          nm_temp_inv_members%ROWTYPE;
--
   l_rec_tii                nm_temp_inv_items%ROWTYPE;
   l_rec_tii_check          nm_temp_inv_items%ROWTYPE;
--
   l_change                 boolean;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'reassemble_individual');
--
   l_tab_rec_tim := get_all_tim_within_ext_limits
                          (p_tim_njc_job_id      => p_njc_job_id
                          ,p_tim_extent_begin_mp => p_extent_begin_mp
                          ,p_tim_extent_end_mp   => p_extent_end_mp
                          ,p_inv_type            => NULL
                          );
--
   FOR i IN 1..l_tab_rec_tim.COUNT
    LOOP
      --
      l_rec_tim      := l_tab_rec_tim(i);
      l_last_rec_tim := l_tab_rec_tim(i);
      --
      l_tab_rec_tim_poss_match.DELETE;
      FOR cs_rec IN cs_tim (c_tim_njc_job_id      => l_rec_tim.tim_njc_job_id
                           ,c_tim_ne_id_in        => l_rec_tim.tim_ne_id_in
                           ,c_tim_extent_begin_mp => l_rec_tim.tim_extent_begin_mp
                           )
       LOOP
         l_tab_rec_tim_poss_match (cs_tim%rowcount) := cs_rec;
      END LOOP;
      --
      l_change := FALSE;
      --
      l_rec_tii := get_tii (p_tii_njc_job_id => l_rec_tim.tim_njc_job_id
                           ,p_tii_ne_id      => l_rec_tim.tim_ne_id_in
                           ,p_tii_ne_id_new  => l_rec_tim.tim_ne_id_in_new
                           );
      --
      FOR j IN 1..l_tab_rec_tim_poss_match.COUNT
       LOOP
      --
         l_rec_tim_check := l_tab_rec_tim_poss_match(j);
      --
         IF l_rec_tim_check.tim_extent_begin_mp > l_last_rec_tim.tim_extent_end_mp
          THEN
            -- There's a gap
            EXIT;
         END IF;
      --
         IF l_rec_tim_check.tim_ne_id_of != l_last_rec_tim.tim_ne_id_of
          THEN
            -- It's on a different datum - don't roll this one up
            EXIT;
         END IF;
      --
         l_rec_tii_check := get_tii (p_tii_njc_job_id => l_rec_tim_check.tim_njc_job_id
                                    ,p_tii_ne_id      => l_rec_tim_check.tim_ne_id_in
                                    ,p_tii_ne_id_new  => l_rec_tim_check.tim_ne_id_in_new
                                    );
      --
         IF NOT are_2_rec_tii_identical (l_rec_tii,l_rec_tii_check)
          THEN
            -- They butt up to one another, but are now different
            EXIT;
         END IF;
      --
         -- They are identical and butt up to one another. Extend the length of the one in memory
         --  (it'll be updated on the DB shortly) and get rid of the other NM_TEM_INV_ITEMS record (it'll cascade)
         --
         l_change                    := TRUE;
         l_rec_tim.tim_extent_end_mp := l_rec_tim_check.tim_extent_end_mp;
--
         delete_tii (p_tii_njc_job_id => l_rec_tim_check.tim_njc_job_id
                    ,p_tii_ne_id      => l_rec_tim_check.tim_ne_id_in
                    ,p_tii_ne_id_new  => l_rec_tim_check.tim_ne_id_in_new
                    );
      --
         l_last_rec_tim              := l_rec_tim_check;
      --
      END LOOP;
      --
      IF l_change
       THEN
         UPDATE nm_temp_inv_members
          SET   tim_extent_end_mp   = l_rec_tim.tim_extent_end_mp
         WHERE  tim_njc_job_id      = l_rec_tim.tim_njc_job_id
          AND   tim_ne_id_in        = l_rec_tim.tim_ne_id_in
          AND   tim_ne_id_in_new    = l_rec_tim.tim_ne_id_in_new
          AND   tim_ne_id_of        = l_rec_tim.tim_ne_id_of
          AND   tim_extent_begin_mp = l_rec_tim.tim_extent_begin_mp;
      END IF;
      --
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'reassemble_individual');
--
END reassemble_individual;
--
-----------------------------------------------------------------------------
--
PROCEDURE delete_tii (p_tii_njc_job_id nm_temp_inv_items.tii_njc_job_id%TYPE
                     ,p_tii_ne_id      nm_temp_inv_items.tii_ne_id%TYPE
                     ,p_tii_ne_id_new  nm_temp_inv_items.tii_ne_id_new%TYPE
                     ) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'delete_tii');
--
   DELETE nm_temp_inv_items
   WHERE  tii_njc_job_id = p_tii_njc_job_id
    AND   tii_ne_id      = p_tii_ne_id
    AND   tii_ne_id_new  = p_tii_ne_id_new;
--
   nm_debug.proc_end(g_package_name,'delete_tii');
--
END delete_tii;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tii (p_tii_njc_job_id nm_temp_inv_items.tii_njc_job_id%TYPE
                 ,p_tii_ne_id      nm_temp_inv_items.tii_ne_id%TYPE
                 ,p_tii_ne_id_new  nm_temp_inv_items.tii_ne_id_new%TYPE
                 ) RETURN nm_temp_inv_items%ROWTYPE IS
--
   CURSOR cs_tii IS
   SELECT *
    FROM  nm_temp_inv_items
   WHERE  tii_njc_job_id = p_tii_njc_job_id
    AND   tii_ne_id      = p_tii_ne_id
    AND   tii_ne_id_new  = p_tii_ne_id_new;
--
   l_found  boolean;
   l_retval nm_temp_inv_items%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_tii');
--
   OPEN  cs_tii;
   FETCH cs_tii INTO l_retval;
   l_found := cs_tii%FOUND;
   CLOSE cs_tii;
--
   IF NOT l_found
    THEN
      hig.raise_ner(pi_appl               => nm3type.c_net
                   ,pi_id                 => 67
                   ,pi_supplementary_info => 'nm_temp_inv_items'
                   );
   END IF;
--
   nm_debug.proc_end(g_package_name,'get_tii');
--
   RETURN l_retval;
--
END get_tii;
--
-----------------------------------------------------------------------------
--
PROCEDURE restore_inventory (p_njc_job_id nm_temp_inv_members.tim_njc_job_id%TYPE) IS
--
   l_rec_njc nm_job_control%ROWTYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'restore_inventory');
--
   l_rec_njc := nm3job.get_njc (p_njc_job_id);
--
   -- Re assemble the data into sensible chunks
   reassemble_chunks (p_njc_job_id);
--
   build_copy_back_sql;
--
   g_tii_njc_job_id := p_njc_job_id;
   g_pl_arr         := nm3pla.defrag_placement_array(nm3pla.get_placement_persistent_ne(l_rec_njc.njc_npe_job_id));
--   nm3pla.dump_placement_array (g_pl_arr);
--
   nm3ddl.debug_tab_varchar(g_tab_vc_copy_back_inv);
   nm3ddl.execute_tab_varchar(g_tab_vc_copy_back_inv);
--   nm_debug.debug_off;
--
   nm_debug.proc_end(g_package_name,'restore_inventory');
--
END restore_inventory;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_copy_back_sql IS
   l_tab_columns       nm3type.tab_varchar30;
   l_tab_columns_child nm3type.tab_varchar30;
BEGIN
--
   nm_debug.proc_start(g_package_name,'build_copy_back_sql');
--
   OPEN  cs_cols (c_table    => c_iit_all
                 ,c_not_col1 => c_iit_ne_id
                 );
   FETCH cs_cols BULK COLLECT INTO l_tab_columns;
   CLOSE cs_cols;
--
   g_tab_vc_copy_back_inv.DELETE;
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'DECLARE',FALSE);
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'-- BUILT IN '||g_package_name||'.build_copy_back_sql');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   c_job_id nm_temp_inv_items.tii_njc_job_id%TYPE := '||g_package_name||'.g_tii_njc_job_id;');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   l_rowcount PLS_INTEGER;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'BEGIN');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
  
   --KA added in v1.9 to avoid stp layer checking
   --should really add a flagto the job types table to determine
   --if this is necessary.
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   nm3merge.set_nw_operation_in_progress;');
   
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   DELETE FROM nm_members_all');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   WHERE nm_ne_id_in IN (SELECT til_iit_ne_id');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                          FROM  nm_temp_inv_items_list');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                         WHERE  til_njc_job_id = c_job_id');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                        );');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   l_rowcount := SQL%ROWCOUNT;');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   nm_debug.debug('||nm3flx.string('members delete :')||'||l_rowcount);');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   DELETE FROM nm_inv_item_groupings_all');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   WHERE EXISTS (SELECT 1');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                  FROM  nm_temp_inv_items_list');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                 WHERE  til_njc_job_id = c_job_id');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                  AND   til_iit_ne_id IN (iig_item_id, iig_parent_id)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                );');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   l_rowcount := SQL%ROWCOUNT;');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   nm_debug.debug('||nm3flx.string('groupings delete :')||'||l_rowcount);');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   DELETE FROM '||c_iit_all);
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   WHERE iit_ne_id IN (SELECT til_iit_ne_id');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                        FROM  nm_temp_inv_items_list');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                       WHERE  til_njc_job_id = c_job_id');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                      );');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   l_rowcount := SQL%ROWCOUNT;');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   nm_debug.debug('||nm3flx.string('inventory delete :')||'||l_rowcount);');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   INSERT INTO '||c_iit_all);
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'          (iit_ne_id');
   FOR i IN 1..l_tab_columns.COUNT
    LOOP
      nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'          ,'||l_tab_columns(i));
   END LOOP;
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'          )');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   SELECT  tii_ne_id_new');
   FOR i IN 1..l_tab_columns.COUNT
    LOOP
      nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'          ,tii'||SUBSTR(l_tab_columns(i),4));
   END LOOP;
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'    FROM   nm_temp_inv_items');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   WHERE  tii_njc_job_id  =  c_job_id');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'    AND   tii_foreign_key IS NULL;');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   l_rowcount := SQL%ROWCOUNT;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   --
   -- JM 19/12/2003 - Had to change this to be a SELECT and then a BULK INSERT because the
   --  function calls to nm3pla.get_lref_from_measure_in_plarr wouldn't work on my 9.2.0.4
   --  DB from within an insert statement. Much oddness
   --
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   DECLARE');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_ne_id_in          nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_ne_id_of          nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_type              nm3type.tab_varchar4;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_obj_type          nm3type.tab_varchar4;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_begin_mp          nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_start_date        nm3type.tab_date;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_end_date          nm3type.tab_date;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_end_mp            nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_slk               nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_cardinality       nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_admin_unit        nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_seq_no            nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_seg_no            nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_nm_true              nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_tim_extent_begin_mp  nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_tab_tim_extent_end_mp    nm3type.tab_number;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      l_lref                     nm_lref;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   BEGIN');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      nm3ausec.set_status(nm3type.c_off);');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      SELECT tim_ne_id_in_new');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,TO_NUMBER(Null) tim_ne_id_of');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_type');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_obj_type');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,TO_NUMBER(Null) nm_begin_mp');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_start_date');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_end_date');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,TO_NUMBER(Null) nm_end_mp');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_slk');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_cardinality');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_admin_unit');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_seq_no');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_seg_no');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_true');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_extent_begin_mp');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,tim_extent_end_mp');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'       BULK  COLLECT');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'       INTO  l_tab_nm_ne_id_in');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_ne_id_of');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_type');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_obj_type');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_begin_mp');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_start_date');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_end_date');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_end_mp');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_slk');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_cardinality');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_admin_unit');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_seq_no');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_seg_no');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_nm_true');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_tim_extent_begin_mp');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'            ,l_tab_tim_extent_end_mp');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'       FROM  nm_temp_inv_members');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      WHERE  tim_njc_job_id = c_job_id');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'       AND   EXISTS (SELECT 1');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                      FROM  '||c_iit_all);
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     WHERE  iit_ne_id = tim_ne_id_in_new');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                    );');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      FOR i IN 1..l_tab_nm_ne_id_in.COUNT');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'       LOOP');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'         l_lref := nm3pla.get_lref_from_measure_in_plarr');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                                     ('||g_package_name||'.g_pl_arr');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                                     ,l_tab_tim_extent_begin_mp(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                                     );');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'         l_tab_nm_ne_id_of(i) := l_lref.get_ne_id;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'         l_tab_nm_begin_mp(i) := l_lref.get_offset;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'         l_tab_nm_end_mp(i)   := nm3pla.get_lref_from_measure_in_plarr');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                                     ('||g_package_name||'.g_pl_arr');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                                     ,l_tab_tim_extent_end_mp(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                                     ,'||nm3flx.string('E'));
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                                     ).get_offset;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      END LOOP;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      FORALL i IN 1..l_tab_nm_ne_id_in.COUNT');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'         INSERT INTO nm_members_all');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                (nm_ne_id_in');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_ne_id_of');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_type');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_obj_type');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_begin_mp');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_start_date');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_end_date');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_end_mp');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_slk');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_cardinality');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_admin_unit');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_seq_no');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_seg_no');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,nm_true');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                )');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'         VALUES (l_tab_nm_ne_id_in(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_ne_id_of(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_type(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_obj_type(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_begin_mp(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_start_date(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_end_date(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_end_mp(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_slk(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_cardinality(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_admin_unit(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_seq_no(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_seg_no(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                ,l_tab_nm_true(i)');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                );');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      INSERT INTO nm_members_all');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             (nm_ne_id_in');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_ne_id_of');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_type');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_obj_type');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_begin_mp');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_start_date');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_end_date');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_end_mp');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_slk');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_cardinality');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_admin_unit');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_seq_no');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_seg_no');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm_true');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             )');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      SELECT  tim_ne_id_in_new');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm3pla.get_lref_from_measure_in_plarr');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     ('||g_package_name||'.g_pl_arr');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     ,tim_extent_begin_mp');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     ).get_ne_id tim_ne_id_of');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,tim_type');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,tim_obj_type');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm3pla.get_lref_from_measure_in_plarr');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     ('||g_package_name||'.g_pl_arr');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     ,tim_extent_begin_mp');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     ).get_offset nm_begin_mp');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,tim_start_date');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,tim_end_date');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,nm3pla.get_lref_from_measure_in_plarr');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     ('||g_package_name||'.g_pl_arr');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     ,tim_extent_end_mp');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     ,'||nm3flx.string('E'));
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     ).get_offset nm_end_mp');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,tim_slk');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,tim_cardinality');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,tim_admin_unit');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,tim_seq_no');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,tim_seg_no');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'             ,tim_true');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'       FROM   nm_temp_inv_members');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      WHERE   tim_njc_job_id = c_job_id');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'       AND    EXISTS (SELECT 1');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                       FROM  '||c_iit_all);
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                      WHERE  iit_ne_id = tim_ne_id_in_new');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'                     );');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      nm3ausec.set_status(nm3type.c_on);');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   EXCEPTION');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'      WHEN others');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'       THEN');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'         nm3ausec.set_status(nm3type.c_on);');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'         RAISE;');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   END;');
   --
   OPEN  cs_cols (c_table    => c_iit_all
                 ,c_not_col1 => c_iit_ne_id
                 ,c_not_col2 => c_foreign_key
                 );
   FETCH cs_cols BULK COLLECT INTO l_tab_columns_child;
   CLOSE cs_cols;
   --
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   INSERT INTO '||c_iit_all);
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'          (iit_ne_id');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'          ,iit_foreign_key');
   FOR i IN 1..l_tab_columns_child.COUNT
    LOOP
      nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'          ,'||l_tab_columns_child(i));
   END LOOP;
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'          )');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   SELECT  tii_ne_id_new');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'          ,'||g_package_name||'.get_new_iit_pk (c_job_id,tii_foreign_key,tii_ne_id,tii_ne_id_new)');
   FOR i IN 1..l_tab_columns_child.COUNT
    LOOP
      nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'          ,tii'||SUBSTR(l_tab_columns_child(i),4));
   END LOOP;
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'    FROM   nm_temp_inv_items');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   WHERE  tii_njc_job_id  =  c_job_id');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'    AND   tii_foreign_key IS NOT NULL;');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   l_rowcount := SQL%ROWCOUNT;');
--   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   nm_debug.debug('||nm3flx.string('inventory insert child :')||'||l_rowcount);');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'--');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'   nm3merge.set_nw_operation_in_progress(FALSE);');
   nm3ddl.append_tab_varchar(g_tab_vc_copy_back_inv,'END;');
--   nm_debug.delete_debug(TRUE);
--   nm_debug.debug_on;
--   nm3ddl.debug_tab_varchar(g_tab_vc_copy_back_inv);
--   FOR cs_rec IN (SELECT * FROM nm_temp_inv_members WHERE tim_njc_job_id = g_tii_njc_job_id)
--    LOOP
--      debug_tim (cs_rec);
--   END LOOP;
--
   nm_debug.proc_end(g_package_name,'build_copy_back_sql');
--
END build_copy_back_sql;
--
-----------------------------------------------------------------------------
--
PROCEDURE debug_tim (pi_rec_tim nm_temp_inv_members%ROWTYPE,p_level pls_integer DEFAULT 3) IS
BEGIN
--
   nm_debug.proc_start(g_package_name,'debug_tim');
--
   nm_debug.DEBUG('-----------------------------------------------------------');
   nm_debug.DEBUG('tim_njc_job_id      : '||pi_rec_tim.tim_njc_job_id,p_level);
   nm_debug.DEBUG('tim_ne_id_in        : '||pi_rec_tim.tim_ne_id_in,p_level);
   nm_debug.DEBUG('tim_ne_id_in_new    : '||pi_rec_tim.tim_ne_id_in_new,p_level);
   nm_debug.DEBUG('tim_ne_id_of        : '||pi_rec_tim.tim_ne_id_of,p_level);
   nm_debug.DEBUG('tim_type            : '||pi_rec_tim.tim_type,p_level);
   nm_debug.DEBUG('tim_obj_type        : '||pi_rec_tim.tim_obj_type,p_level);
   nm_debug.DEBUG('tim_start_date      : '||pi_rec_tim.tim_start_date,p_level);
   nm_debug.DEBUG('tim_end_date        : '||pi_rec_tim.tim_end_date,p_level);
   nm_debug.DEBUG('tim_slk             : '||pi_rec_tim.tim_slk,p_level);
   nm_debug.DEBUG('tim_cardinality     : '||pi_rec_tim.tim_cardinality,p_level);
   nm_debug.DEBUG('tim_admin_unit      : '||pi_rec_tim.tim_admin_unit,p_level);
   nm_debug.DEBUG('tim_date_created    : '||pi_rec_tim.tim_date_created,p_level);
   nm_debug.DEBUG('tim_date_modified   : '||pi_rec_tim.tim_date_modified,p_level);
   nm_debug.DEBUG('tim_modified_by     : '||pi_rec_tim.tim_modified_by,p_level);
   nm_debug.DEBUG('tim_created_by      : '||pi_rec_tim.tim_created_by,p_level);
   nm_debug.DEBUG('tim_seq_no          : '||pi_rec_tim.tim_seq_no,p_level);
   nm_debug.DEBUG('tim_seg_no          : '||pi_rec_tim.tim_seg_no,p_level);
   nm_debug.DEBUG('tim_true            : '||pi_rec_tim.tim_true,p_level);
   nm_debug.DEBUG('tim_extent_begin_mp : '||pi_rec_tim.tim_extent_begin_mp,p_level);
   nm_debug.DEBUG('tim_extent_end_mp   : '||pi_rec_tim.tim_extent_end_mp,p_level);
--
   nm_debug.proc_end(g_package_name,'debug_tim');
--
END debug_tim;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_copy_sql (pi_include_children boolean) IS
BEGIN
--
   nm_debug.proc_end(g_package_name,'build_copy_sql');
--
   DECLARE
      leave_it_alone EXCEPTION;
      l_inv_cols_tab nm3type.tab_varchar30;
   BEGIN
   --
      IF g_tab_vc_copy_inv.COUNT = 0
       OR pi_include_children != g_last_copy_children
       THEN
         -- If the array is empty, or the include children instruction is different to
         --   the last time it was called then we need to rebuild the SQL
         g_last_copy_children := pi_include_children;
      ELSE
         -- Nothing has changed, so reuse the same block
         RAISE leave_it_alone;
      END IF;
   --
      OPEN  cs_cols (c_iit);
      FETCH cs_cols BULK COLLECT INTO l_inv_cols_tab;
      CLOSE cs_cols;
   --
      IF l_inv_cols_tab.COUNT = 0
       THEN
         hig.raise_ner(pi_appl               => nm3type.c_net
                      ,pi_id                 => 28
                      ,pi_supplementary_info => g_package_name||'.build_copy_sql - no columns found for '||c_iit
                      );
      END IF;
   --
      g_tab_vc_copy_inv.DELETE;
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'DECLARE',FALSE);
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'--');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   c_inv_type   CONSTANT nm_inv_types.nit_inv_type%TYPE        := '||g_package_name||'.g_inv_type;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   c_job_id     CONSTANT nm_temp_inv_items.tii_njc_job_id%TYPE := '||g_package_name||'.g_tii_njc_job_id;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   c_nte_job_id CONSTANT nm_nw_temp_extents.nte_job_id%TYPE    := '||g_package_name||'.g_nte_job_id;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq             nm_gaz_query%ROWTYPE;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngqt            nm_gaz_query_types%ROWTYPE;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_item_list           NUMBER;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'--');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'BEGIN');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'--');
      
      --nm_debug.DEBUG('build copy sql - is_nw_operation_in_progress = ' || nm3flx.boolean_to_char(nm3merge.is_nw_operation_in_progress));
      
      --IF nm3merge.is_nw_operation_in_progress
      --THEN
        
      --END IF;

      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_id                 := nm3seq.next_ngq_id_seq;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_source_id          := c_nte_job_id;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_source             := nm3extent.c_temp_ne;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_open_or_closed     := nm3gaz_qry.c_closed_query;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_items_or_area      := nm3gaz_qry.c_items_query;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_query_all_items    := '||nm3flx.string('N')||';');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_begin_mp           := Null;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_begin_datum_ne_id  := Null;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_begin_datum_offset := Null;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_end_mp             := Null;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_end_datum_ne_id    := Null;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_end_datum_offset   := Null;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngq.ngq_ambig_sub_class    := Null;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   nm3ins.ins_ngq (l_rec_ngq);');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngqt.ngqt_ngq_id            := l_rec_ngq.ngq_id;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngqt.ngqt_seq_no            := 1;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngqt.ngqt_item_type_type    := nm3gaz_qry.c_ngqt_item_type_type_inv;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_rec_ngqt.ngqt_item_type         := c_inv_type;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   nm3ins.ins_ngqt(l_rec_ngqt);');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'--');
      --
      -- Perform the gaz query to get all of the "parent" data
      --
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   l_item_list := nm3gaz_qry.perform_query (pi_ngq_id => l_rec_ngq.ngq_id);');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'--');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   DELETE FROM nm_gaz_query');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   WHERE ngq_id = l_rec_ngq.ngq_id;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'--');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   INSERT INTO '||c_tii);
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'         (tii_njc_job_id');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'         ,tii_primary_key_orig');
      FOR l_i IN 1..l_inv_cols_tab.COUNT
       LOOP
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'         ,tii'||SUBSTR(l_inv_cols_tab(l_i), 4));
      END LOOP;
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'         )');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   SELECT c_job_id');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'         ,iit_primary_key');
      FOR l_i IN 1..l_inv_cols_tab.COUNT
       LOOP
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'         ,'||l_inv_cols_tab(l_i));
      END LOOP;
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'    FROM  '||c_iit||' iit');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   WHERE  iit.iit_ne_id IN (SELECT ngqi_item_id');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                             FROM  nm_gaz_query_item_list');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                            WHERE  ngqi_job_id = l_item_list');
      IF pi_include_children
       THEN
         -- If we are including children then get all children which have (as parents) the items identified
         --  by the gaz qry
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                            UNION');
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                            SELECT iig_item_id');
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                             FROM  nm_gaz_query_item_list');
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                                  ,nm_inv_item_groupings');
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                            WHERE  ngqi_job_id   = l_item_list');
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                             AND   iig_parent_id = ngqi_item_id');
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                            UNION');
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                            SELECT iig_item_id');
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                             FROM  nm_gaz_query_item_list');
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                                  ,nm_inv_item_groupings');
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                            WHERE  ngqi_job_id   = l_item_list');
         nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                             AND   iig_top_id    = ngqi_item_id');
      END IF;
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'                           );');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'--');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   DELETE FROM nm_gaz_query_item_list');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   WHERE ngqi_job_id = l_item_list;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'--');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   INSERT INTO nm_temp_inv_items_list');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'         (til_njc_job_id');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'         ,til_iit_ne_id ');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'         )');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   SELECT tii_njc_job_id');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'         ,tii_ne_id');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'    FROM  nm_temp_inv_items');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'   WHERE  tii_njc_job_id = c_job_id;');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'--');
      nm3ddl.append_tab_varchar(g_tab_vc_copy_inv,'END;');
   EXCEPTION
      WHEN leave_it_alone THEN NULL;
   END;
--
   nm_debug.proc_end(g_package_name,'build_copy_sql');
--
END build_copy_sql;
--
-----------------------------------------------------------------------------
--
FUNCTION get_new_iit_pk (pi_job_id    nm_temp_inv_items.tii_njc_job_id%TYPE
                        ,pi_old_pk    nm_temp_inv_items.tii_primary_key%TYPE
                        ,pi_ne_id_old nm_temp_inv_items.tii_ne_id%TYPE
                        ,pi_ne_id_new nm_temp_inv_items.tii_ne_id_new%TYPE
                        ) RETURN nm_temp_inv_items.tii_primary_key%TYPE IS
--
   CURSOR cs_pk (c_job_id nm_temp_inv_items.tii_njc_job_id%TYPE
                ,c_old_pk nm_temp_inv_items.tii_primary_key%TYPE
                ) IS
   SELECT *
    FROM  nm_temp_inv_items
   WHERE  tii_njc_job_id       = c_job_id
    AND   tii_primary_key_orig = c_old_pk;
--
   l_retval nm_temp_inv_items.tii_primary_key%TYPE;
--
BEGIN
--
--   nm_debug.debug('-===================');
--   nm_debug.debug('pi_old_pk     : '||pi_old_pk);
--   nm_debug.debug('pi_ne_id_old  : '||pi_ne_id_old);
--   nm_debug.debug('pi_ne_id_new  : '||pi_ne_id_new);
   FOR cs_rec IN cs_pk (c_job_id => pi_job_id
                       ,c_old_pk => pi_old_pk
                       )
    LOOP
--      nm_debug.debug(cs_pk%ROWCOUNT);
--      nm_debug.debug('cs_rec.tii_ne_id     : '||cs_rec.tii_ne_id);
--      nm_debug.debug('cs_rec.tii_ne_id_new : '||cs_rec.tii_ne_id_new);
      IF temp_locations_are_coincident
                        (pi_job_id      => pi_job_id
                        ,pi_ne_id_old_1 => pi_ne_id_old
                        ,pi_ne_id_new_1 => pi_ne_id_new
                        ,pi_ne_id_old_2 => cs_rec.tii_ne_id
                        ,pi_ne_id_new_2 => cs_rec.tii_ne_id_new
                        )
       THEN
--         nm_debug.debug('Hoorah! Match found');
         l_retval := cs_rec.tii_primary_key;
         EXIT;
--      ELSE
--         nm_debug.debug('Boo! No Match found');
      END IF;
   END LOOP;
--   nm_debug.debug('Out of loop RETVAL ="'||l_retval||'"');
--
   RETURN l_retval;
--
END get_new_iit_pk;
--
-----------------------------------------------------------------------------
--
FUNCTION temp_locations_are_coincident
                        (pi_job_id      nm_temp_inv_items.tii_njc_job_id%TYPE
                        ,pi_ne_id_old_1 nm_temp_inv_items.tii_ne_id%TYPE
                        ,pi_ne_id_new_1 nm_temp_inv_items.tii_ne_id_new%TYPE
                        ,pi_ne_id_old_2 nm_temp_inv_items.tii_ne_id%TYPE
                        ,pi_ne_id_new_2 nm_temp_inv_items.tii_ne_id_new%TYPE
                        ) RETURN boolean IS
--
   CURSOR cs_check IS
   SELECT 1
    FROM  nm_temp_inv_members tim1
         ,nm_temp_inv_members tim2
   WHERE  tim1.tim_njc_job_id      = pi_job_id
    AND   tim1.tim_ne_id_in        = pi_ne_id_old_1
    AND   tim1.tim_ne_id_in_new    = pi_ne_id_new_1
    AND   tim2.tim_njc_job_id      = pi_job_id
    AND   tim2.tim_ne_id_in        = pi_ne_id_old_2
    AND   tim2.tim_ne_id_in_new    = pi_ne_id_new_2
    AND   tim1.tim_ne_id_of        = tim2.tim_ne_id_of
    AND   tim1.tim_extent_begin_mp = tim2.tim_extent_begin_mp;
--
   l_dummy  pls_integer;
   l_retval boolean;
--
BEGIN
--
   OPEN  cs_check;
   FETCH cs_check INTO l_dummy;
   l_retval := cs_check%FOUND;
   CLOSE cs_check;
--
   RETURN l_retval;
--
END temp_locations_are_coincident;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_rec_tii (p_rec_tii nm_temp_inv_items%ROWTYPE) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'validate_rec_tii');
--
   IF g_tab_compare_sql.COUNT = 0
    THEN
      build_compare_sql;
   END IF;
--
   g_rec_tii := p_rec_tii;
--
   nm3ddl.execute_tab_varchar(g_tab_compare_sql);
--
   nm_debug.proc_end (g_package_name,'validate_rec_tii');
--
END validate_rec_tii;
--
-----------------------------------------------------------------------------
--
PROCEDURE build_compare_sql IS
   l_tab_cols nm3type.tab_varchar30;
BEGIN
--
   OPEN  cs_cols (c_table => c_iit
                 );
   FETCH cs_cols BULK COLLECT INTO l_tab_cols;
   CLOSE cs_cols;
--
   g_tab_compare_sql.DELETE;
   nm3ddl.append_tab_varchar(g_tab_compare_sql,'DECLARE',FALSE);
   nm3ddl.append_tab_varchar(g_tab_compare_sql,'   l_rec_iit nm_inv_items%ROWTYPE;');
   nm3ddl.append_tab_varchar(g_tab_compare_sql,'BEGIN');
   nm3ddl.append_tab_varchar(g_tab_compare_sql,'--');
   FOR i IN 1..l_tab_cols.COUNT
    LOOP
      nm3ddl.append_tab_varchar(g_tab_compare_sql,'   l_rec_iit.'||l_tab_cols(i)||' := '||g_package_name||'.g_rec_tii.tii'||SUBSTR(l_tab_cols(i),4)||';');
   END LOOP;
   nm3ddl.append_tab_varchar(g_tab_compare_sql,'--');
   nm3ddl.append_tab_varchar(g_tab_compare_sql,'   nm3inv.validate_rec_iit(l_rec_iit);');
   nm3ddl.append_tab_varchar(g_tab_compare_sql,'--');
   nm3ddl.append_tab_varchar(g_tab_compare_sql,'END;');
--
END build_compare_sql;
--
---------------------------------------------------------------------------
--
END nm3inv_temp;
/
