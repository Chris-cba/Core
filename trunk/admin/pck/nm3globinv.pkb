CREATE OR REPLACE PACKAGE BODY nm3globinv AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3globinv.pkb-arc   2.3   Jul 04 2013 16:04:12   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3globinv.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 16:04:12  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:12  $
--       Version          : $Revision:   2.3  $
--       Based on SCCS version : 1.7
-------------------------------------------------------------------------
--   Author : Jonathan Mills
--
--   Global Inventory Update Package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------
--
--all global package variables here
--
--  g_body_sccsid is the SCCS ID for the package body
   g_body_sccsid        CONSTANT varchar2(2000) := '$Revision:   2.3  $';
   g_package_name    CONSTANT  varchar2(30)   := 'nm3globinv';
--
   g_tab_pre_val_format  nm3type.tab_varchar30;
   g_tab_post_val_format nm3type.tab_varchar30;
   g_tab_mandatory       nm3type.tab_boolean;
--
   g_temp_ne_pl_arr nm_placement_array;
--
   g_arr_pos           BINARY_INTEGER := 0;
--
--- Package Private Procedures ----------------------------------------------
--
PROCEDURE create_nqg_records (pi_nte_job_id                IN     nm_nw_temp_extents.nte_job_id%TYPE
                             ,pi_inv_type                  IN     nm_inv_types.nit_inv_type%TYPE
                             ,pi_attrib_name               IN     nm3type.tab_varchar30
                             ,pi_old_value                 IN     nm3type.tab_varchar2000
                             ,po_ngq_id                       OUT nm_gaz_query.ngq_id%TYPE
                             );
--
---- Global Procedures ------------------------------------------------------
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
PROCEDURE get_affected_and_overhangs
               (pi_nte_job_id                IN     nm_nw_temp_extents.nte_job_id%TYPE
               ,pi_inv_type                  IN     nm_inv_types.nit_inv_type%TYPE
               ,pi_attrib_name               IN     nm3type.tab_varchar30
               ,pi_old_value                 IN     nm3type.tab_varchar2000
               ,po_tab_all_iit_ne_id            OUT nm3type.tab_number
               ,po_tab_overhanging_iit_ne_id    OUT nm3type.tab_varchar30
               ) IS
--
--   l_sql_string varchar2(32767);
----
--   l_cur nm3type.ref_cursor;
--
   l_iit_ne_id nm_inv_items.iit_ne_id%TYPE;
--
--   l_inv_placement nm_placement_array;
--   l_pl_arr_relation varchar2(30);
--
   l_ngq_id      nm_gaz_query.ngq_id%TYPE;
   l_ngqi_job_id nm_gaz_query_item_list.ngqi_job_id%TYPE;
   l_nte_job_id  nm_nw_temp_extents.nte_job_id%TYPE;
--
   l_tab_nte_1      nm3extent.tab_nte;
   l_tab_nte_2      nm3extent.tab_nte;
   l_tab_nte_result nm3extent.tab_nte;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'get_affected_and_overhangs');
--
   -- Empty the return arrays
   po_tab_all_iit_ne_id.DELETE;
   po_tab_overhanging_iit_ne_id.DELETE;
--
   IF   pi_attrib_name.COUNT  = 0
    OR  pi_attrib_name.COUNT != pi_old_value.COUNT
    THEN
      -- Arrays supplied have different numbers of values.
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 91
                    );
   END IF;
--
   create_nqg_records (pi_nte_job_id  => pi_nte_job_id
                      ,pi_inv_type    => pi_inv_type
                      ,pi_attrib_name => pi_attrib_name
                      ,pi_old_value   => pi_old_value
                      ,po_ngq_id      => l_ngq_id
                      );
--
   l_ngqi_job_id := nm3gaz_qry.perform_query (pi_ngq_id => l_ngq_id);
--
   SELECT ngqi_item_id
    BULK  COLLECT
    INTO  po_tab_all_iit_ne_id
    FROM  nm_gaz_query_item_list
   WHERE  ngqi_job_id = l_ngqi_job_id;
--
   l_tab_nte_2 := nm3extent.get_tab_nte (pi_nte_id => pi_nte_job_id);
--
   FOR i IN 1..po_tab_all_iit_ne_id.COUNT
    LOOP
      nm3extent.create_temp_ne (pi_source_id   => po_tab_all_iit_ne_id(i)
                               ,pi_source      => nm3extent.c_route
                               ,po_job_id      => l_nte_job_id
                               );
      l_tab_nte_1 := nm3extent.get_tab_nte (pi_nte_id => l_nte_job_id);
      nm3extent.nte_minus_nte (pi_nte_1      => l_tab_nte_1
                              ,pi_nte_2      => l_tab_nte_2
                              ,po_nte_result => l_tab_nte_result
                              );
      IF l_tab_nte_result.COUNT != 0
       THEN
         po_tab_overhanging_iit_ne_id (po_tab_all_iit_ne_id(i)) := 'OVERHANG';
      END IF;
   END LOOP;
--
   nm_debug.proc_end(g_package_name,'get_affected_and_overhangs');
--
END get_affected_and_overhangs;
--
-----------------------------------------------------------------------------
--
FUNCTION get_affected_and_overhangs
               (pi_nte_job_id                IN     nm_nw_temp_extents.nte_job_id%TYPE
               ,pi_inv_type                  IN     nm_inv_types.nit_inv_type%TYPE
               ,pi_attrib_name               IN     nm3type.tab_varchar30
               ,pi_old_value                 IN     nm3type.tab_varchar2000
               ) RETURN boolean IS
--
   l_tab_all_iit_ne_id         nm3type.tab_number;
   l_tab_overhanging_iit_ne_id nm3type.tab_varchar30;
   l_retval                    boolean;
--
BEGIN
--
    get_affected_and_overhangs
               (pi_nte_job_id                => pi_nte_job_id
               ,pi_inv_type                  => pi_inv_type
               ,pi_attrib_name               => pi_attrib_name
               ,pi_old_value                 => pi_old_value
               ,po_tab_all_iit_ne_id         => l_tab_all_iit_ne_id
               ,po_tab_overhanging_iit_ne_id => l_tab_overhanging_iit_ne_id
               );
--
   RETURN (l_tab_overhanging_iit_ne_id.COUNT != 0);
--
END get_affected_and_overhangs;
--
-----------------------------------------------------------------------------
--
PROCEDURE global_inventory_update
               (pi_nte_job_id     IN     nm_nw_temp_extents.nte_job_id%TYPE
               ,pi_inv_type       IN     nm_inv_types.nit_inv_type%TYPE
               ,pi_attrib_name    IN     nm_inv_type_attribs.ita_attrib_name%TYPE
               ,pi_old_value      IN     varchar2
               ,pi_new_value      IN     varchar2
               ,pi_overhang_rule  IN     varchar2
               ,po_iit_ne_id_done    OUT nm3type.tab_number
               ) IS
--
   l_attrib_name nm3type.tab_varchar30;
   l_old_value   nm3type.tab_varchar2000;
   l_new_value   nm3type.tab_varchar2000;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'global_inventory_update');
--
   l_attrib_name(1) := pi_attrib_name;
   l_old_value(1)   := pi_old_value;
   l_new_value(1)   := pi_new_value;
--
   global_inventory_update
               (pi_nte_job_id     => pi_nte_job_id
               ,pi_inv_type       => pi_inv_type
               ,pi_attrib_name    => l_attrib_name
               ,pi_old_value      => l_old_value
               ,pi_new_value      => l_new_value
               ,pi_overhang_rule  => pi_overhang_rule
               ,po_iit_ne_id_done => po_iit_ne_id_done
               );
--
   nm_debug.proc_end(g_package_name,'global_inventory_update');
--
END global_inventory_update;
--
-----------------------------------------------------------------------------
--
PROCEDURE global_inventory_update
               (pi_nte_job_id     IN     nm_nw_temp_extents.nte_job_id%TYPE
               ,pi_inv_type       IN     nm_inv_types.nit_inv_type%TYPE
               ,pi_attrib_name    IN     nm_inv_type_attribs.ita_attrib_name%TYPE
               ,pi_old_value      IN     varchar2
               ,pi_new_value      IN     varchar2
               ,pi_overhang_rule  IN     varchar2
               ,pi_count_iit_done    OUT NUMBER
               ) IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'global_inventory_update');
--
   global_inventory_update
               (pi_nte_job_id     => pi_nte_job_id
               ,pi_inv_type       => pi_inv_type
               ,pi_attrib_name    => pi_attrib_name
               ,pi_old_value      => pi_old_value
               ,pi_new_value      => pi_new_value
               ,pi_overhang_rule  => pi_overhang_rule
               ,po_iit_ne_id_done => g_tab_ne_id_updated
               );
--
   pi_count_iit_done := g_tab_ne_id_updated.COUNT;
--
   nm_debug.proc_end(g_package_name,'global_inventory_update');
--
END global_inventory_update;
--
-----------------------------------------------------------------------------
--
PROCEDURE global_inventory_update
               (pi_nte_job_id     IN     nm_nw_temp_extents.nte_job_id%TYPE
               ,pi_inv_type       IN     nm_inv_types.nit_inv_type%TYPE
               ,pi_attrib_name    IN     nm3type.tab_varchar30
               ,pi_old_value      IN     nm3type.tab_varchar2000
               ,pi_new_value      IN     nm3type.tab_varchar2000
               ,pi_overhang_rule  IN     varchar2
               ,pi_count_iit_done    OUT NUMBER
               ) IS
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'global_inventory_update');
--
   global_inventory_update
               (pi_nte_job_id     => pi_nte_job_id
               ,pi_inv_type       => pi_inv_type
               ,pi_attrib_name    => pi_attrib_name
               ,pi_old_value      => pi_old_value
               ,pi_new_value      => pi_new_value
               ,pi_overhang_rule  => pi_overhang_rule
               ,po_iit_ne_id_done => g_tab_ne_id_updated
               );
--
   pi_count_iit_done := g_tab_ne_id_updated.COUNT;
--
   nm_debug.proc_end(g_package_name,'global_inventory_update');
--
END global_inventory_update;
--
-----------------------------------------------------------------------------
--
PROCEDURE global_inventory_update
               (pi_nte_job_id     IN     nm_nw_temp_extents.nte_job_id%TYPE
               ,pi_inv_type       IN     nm_inv_types.nit_inv_type%TYPE
               ,pi_attrib_name    IN     nm3type.tab_varchar30
               ,pi_old_value      IN     nm3type.tab_varchar2000
               ,pi_new_value      IN     nm3type.tab_varchar2000
               ,pi_overhang_rule  IN     varchar2
               ,po_iit_ne_id_done    OUT nm3type.tab_number
               ) IS
--
   l_tab_all        nm3type.tab_number;
   l_tab_overhangs  nm3type.tab_varchar30;
   l_rowid          ROWID;
--
   l_block          nm3type.tab_varchar32767;
   l_some_different boolean := FALSE;
   l_start          VARCHAR2(13) := '       SET   ';
--
   PROCEDURE append (p_text VARCHAR2, p_nl BOOLEAN DEFAULT TRUE) IS
   BEGIN
      nm3ddl.append_tab_varchar (l_block, p_text, p_nl);
   END append;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'global_inventory_update');
--
   g_arr_pos := 0;
   g_tab_ne_id_updated.DELETE;
--
   IF pi_overhang_rule NOT IN (c_update,c_leave) --,c_split)
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 88
                    );
   END IF;
--
   IF   pi_attrib_name.COUNT  = 0
    OR  pi_attrib_name.COUNT != pi_old_value.COUNT
    OR  pi_attrib_name.COUNT != pi_new_value.COUNT
    THEN
      -- Arrays supplied have different numbers of values.
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 91
                    );
   END IF;
--
   get_affected_and_overhangs
                 (pi_nte_job_id                => pi_nte_job_id
                 ,pi_inv_type                  => pi_inv_type
                 ,pi_attrib_name               => pi_attrib_name
                 ,pi_old_value                 => pi_old_value
                 ,po_tab_all_iit_ne_id         => l_tab_all
                 ,po_tab_overhanging_iit_ne_id => l_tab_overhangs
                 );
--
   append ('BEGIN');
   append ('   nm3inv.bypass_inv_items_all_trgs(TRUE);');
   append ('   FORALL i IN 1..'||g_package_name||'.g_tab_ne_id_updated.COUNT');
   append ('      UPDATE nm_inv_items');
   FOR i IN 1..pi_attrib_name.COUNT
    LOOP
      --
      IF NVL(pi_old_value(i),nm3type.c_nvl) != NVL(pi_new_value(i),nm3type.c_nvl)
       THEN
         --
         -- Only bother updating if the 2 values are different
         --
         l_some_different := TRUE;
         append (l_start||pi_attrib_name(i)||' = ');
         l_start := '            ,';
         append (nm3flx.i_t_e (pi_new_value(i) IS NULL
                              ,'Null'
                              ,nm3pbi.fn_convert_attrib_value(pi_value  => pi_new_value(i)
                                                             ,pi_format => nm3gaz_qry.get_attrib_datatype (p_ngqt_item_type_type => nm3gaz_qry.c_ngqt_item_type_type_inv
                                                                                                          ,p_ngqt_item_type      => pi_inv_type
                                                                                                          ,p_ngqa_attrib_name    => pi_attrib_name(i)
                                                                                                          )
                                                             )
                              )
                ,FALSE
                );
      END IF;
   END LOOP;
   append ('      WHERE  iit_ne_id = '||g_package_name||'.g_tab_ne_id_updated(i);');
   append ('   nm3inv.bypass_inv_items_all_trgs(FALSE);');
   append ('END;');
         --
   IF NOT l_some_different
    THEN
      -- All old and new values specified are the same.
      hig.raise_ner (pi_appl => nm3type.c_hig
                    ,pi_id   => 92
                    );
   END IF;
--
   FOR l_count IN 1..l_tab_all.COUNT
    LOOP
      DECLARE
         l_dont_process   EXCEPTION;
         l_iit_ne_id      nm_inv_items.iit_ne_id%TYPE := l_tab_all(l_count);
      BEGIN
         IF   pi_overhang_rule = c_leave
          AND l_tab_overhangs.EXISTS(l_iit_ne_id)
          THEN
            -- If this IIT_NE_ID has an overhang and we are leaving it
            RAISE l_dont_process;
         ELSIF pi_overhang_rule = c_split
          AND  l_tab_overhangs.EXISTS(l_iit_ne_id)
          THEN
            --
            -- Do some other guff here - COPY_INV, split up the orig placement etc
            --
            -- 1. Date Track update the inventory record (record 1)
            -- 2. Copy the new inventory record (record 2)
            -- 3. Relocate 1 over the area of it's existence which exists in the temp ne
            -- 4. Relocate 2 over the rest of Record 1's original area
            --
            Null;
         END IF;
         nm3lock.lock_inv_item (pi_iit_ne_id      => l_iit_ne_id
                               ,p_lock_for_update => TRUE
                               );
         g_tab_ne_id_updated(g_tab_ne_id_updated.COUNT+1) := l_iit_ne_id;
--
      EXCEPTION
         WHEN l_dont_process
          THEN
            NULL;
      END;
   END LOOP;
--
nm_debug.debug_on;
nm_debug.debug('EXECUTING FOLLOWING UPDATE STATEMENT...');
nm3tab_varchar.debug_tab_varchar(l_block);
--
   nm3ddl.execute_tab_varchar (l_block);
--
   po_iit_ne_id_done := g_tab_ne_id_updated;
--
   nm_debug.proc_end(g_package_name,'global_inventory_update');
--
nm_debug.debug_off;
EXCEPTION
 WHEN OTHERS THEN
   nm_debug.debug_off;
   nm3inv.bypass_inv_items_all_trgs(FALSE);
   RAISE;
END global_inventory_update;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_update RETURN varchar2 IS
BEGIN
  RETURN c_update;
END get_c_update;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_leave RETURN varchar2 IS
BEGIN
  RETURN c_leave;
END get_c_leave;
--
-----------------------------------------------------------------------------
--
FUNCTION get_c_split RETURN varchar2 IS
BEGIN
  RETURN c_split;
END get_c_split;
--
-----------------------------------------------------------------------------
--
FUNCTION get_next_ne_id_from_tab RETURN nm_inv_items.iit_ne_id%TYPE IS
--
BEGIN
--
   g_arr_pos := NVL(g_arr_pos,0)+1;
--
   IF NOT g_tab_ne_id_updated.EXISTS(g_arr_pos)
    THEN
      RETURN Null;
   ELSE
      RETURN g_tab_ne_id_updated(g_arr_pos);
   END IF;
--
END get_next_ne_id_from_tab;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_nqg_records (pi_nte_job_id                IN     nm_nw_temp_extents.nte_job_id%TYPE
                             ,pi_inv_type                  IN     nm_inv_types.nit_inv_type%TYPE
                             ,pi_attrib_name               IN     nm3type.tab_varchar30
                             ,pi_old_value                 IN     nm3type.tab_varchar2000
                             ,po_ngq_id                       OUT nm_gaz_query.ngq_id%TYPE
                             ) IS
--
   l_rec_ngq  nm_gaz_query%ROWTYPE;
   l_rec_ngqt nm_gaz_query_types%ROWTYPE;
   l_rec_ngqa nm_gaz_query_attribs%ROWTYPE;
   l_rec_ngqv nm_gaz_query_values%ROWTYPE;
--
BEGIN
--
   po_ngq_id                         := nm3seq.next_ngq_id_seq;
   l_rec_ngq.ngq_id                  := po_ngq_id;
   l_rec_ngq.ngq_source_id           := pi_nte_job_id;
   l_rec_ngq.ngq_source              := nm3extent.c_temp_ne;
   l_rec_ngq.ngq_open_or_closed      := nm3gaz_qry.c_closed_query;
   l_rec_ngq.ngq_items_or_area       := nm3gaz_qry.c_items_query;
   l_rec_ngq.ngq_query_all_items     := 'N';
   l_rec_ngq.ngq_begin_mp            := Null;
   l_rec_ngq.ngq_begin_datum_ne_id   := Null;
   l_rec_ngq.ngq_begin_datum_offset  := Null;
   l_rec_ngq.ngq_end_mp              := Null;
   l_rec_ngq.ngq_end_datum_ne_id     := Null;
   l_rec_ngq.ngq_end_datum_offset    := Null;
   l_rec_ngq.ngq_ambig_sub_class     := Null;
   nm3ins.ins_ngq (l_rec_ngq);
--
   l_rec_ngqt.ngqt_ngq_id            := l_rec_ngq.ngq_id;
   l_rec_ngqt.ngqt_seq_no            := nm3seq.next_ngqt_seq_no_seq;
   l_rec_ngqt.ngqt_item_type_type    := nm3gaz_qry.c_ngqt_item_type_type_inv;
   l_rec_ngqt.ngqt_item_type         := pi_inv_type;
   nm3ins.ins_ngqt (l_rec_ngqt);
--
   l_rec_ngqa.ngqa_ngq_id            := l_rec_ngqt.ngqt_ngq_id;
   l_rec_ngqa.ngqa_ngqt_seq_no       := l_rec_ngqt.ngqt_seq_no;
   l_rec_ngqa.ngqa_operator          := nm3type.c_and_operator;
   l_rec_ngqa.ngqa_pre_bracket       := Null;
   l_rec_ngqa.ngqa_post_bracket      := Null;
--
   l_rec_ngqv.ngqv_ngq_id            := l_rec_ngqa.ngqa_ngq_id;
   l_rec_ngqv.ngqv_ngqt_seq_no       := l_rec_ngqa.ngqa_ngqt_seq_no;
   l_rec_ngqv.ngqv_sequence          := 1;
--
   FOR i IN 1..pi_attrib_name.COUNT
    LOOP
--
      --
      -- Check each attribute only specified once
      --
      FOR l_check_count IN 1..pi_attrib_name.COUNT
       LOOP
         IF   l_check_count    != i
          AND pi_attrib_name(i) = pi_attrib_name(l_check_count)
          THEN
            -- Attribute specified more than once.
            hig.raise_ner (pi_appl               => nm3type.c_net
                          ,pi_id                 => 91
                          ,pi_supplementary_info => pi_attrib_name(i)
                          );
         END IF;
      END LOOP;
--
      l_rec_ngqa.ngqa_seq_no         := i;
      l_rec_ngqa.ngqa_attrib_name    := pi_attrib_name(i);
      IF pi_old_value(i) IS NULL
       THEN
         l_rec_ngqa.ngqa_condition   := 'IS NULL';
         nm3ins.ins_ngqa (l_rec_ngqa);
      ELSE
         l_rec_ngqa.ngqa_condition   := '=';
         nm3ins.ins_ngqa (l_rec_ngqa);
         l_rec_ngqv.ngqv_ngqa_seq_no := l_rec_ngqa.ngqa_seq_no;
         l_rec_ngqv.ngqv_value       := pi_old_value(i);
         nm3ins.ins_ngqv (l_rec_ngqv);
      END IF;
   END LOOP;
--
END create_nqg_records;
--
-----------------------------------------------------------------------------
--
FUNCTION get_tab_of_updated_items RETURN nm_id_tbl IS

 l_retval nm_id_tbl := nm_id_tbl();

BEGIN

for i in 1..g_tab_ne_id_updated.count loop

 l_retval.extend;
 l_retval(l_retval.count) := g_tab_ne_id_updated(i);
end loop;


return(l_retval);


END get_tab_of_updated_items;


END nm3globinv;
/
