CREATE OR REPLACE PACKAGE BODY nm3ausec_maint AS
--
--   PVCS Identifiers :-
--
--       pvcsid                 : $Header:   //vm_latest/archives/nm3/admin/pck/nm3ausec_maint.pkb-arc   2.6   Jul 04 2013 15:23:04   James.Wadsworth  $
--       Module Name      : $Workfile:   nm3ausec_maint.pkb  $
--       Date into PVCS   : $Date:   Jul 04 2013 15:23:04  $
--       Date fetched Out : $Modtime:   Jul 04 2013 14:25:10  $
--       PVCS Version     : $Revision:   2.6  $
--       Based on SCCS version : 1.4
--
--   Author : Jonathan Mills
--
--   NM3 Admin Unit Security Maintenance package body
--
-----------------------------------------------------------------------------
--   Copyright (c) 2013 Bentley Systems Incorporated. All rights reserved.
-----------------------------------------------------------------------------

/* History
  23.11.07 PT fixed a bug in process_each_inv_item() whereby the continous item placements were not dealt properly
                fixed by removing an unnecessary temp extent creation.
  23.04.08 PT modified the above by creating the intersect temp extent manually for continuous items.
*/

--
   g_body_sccsid     CONSTANT  varchar2(2000) := '"$Revision:   2.6  $"';
   g_package_name    CONSTANT  varchar2(30)   := 'nm3ausec_maint';
--
   TYPE rec_parent IS RECORD
      (old_iit_ne_id       nm_inv_items.iit_ne_id%TYPE
      ,new_iit_ne_id       nm_inv_items.iit_ne_id%TYPE
      ,old_child_iit_ne_id nm_inv_items.iit_ne_id%TYPE
      );
   TYPE tab_rec_parent IS TABLE OF rec_parent INDEX BY binary_integer;
   g_tab_rec_parent tab_rec_parent;
--
   TYPE tab_rec_iig    IS TABLE OF nm_inv_item_groupings%ROWTYPE INDEX BY binary_integer;
   g_tab_rec_iig    tab_rec_iig;
--
   g_tab_ne_id      nm3type.tab_number;
--
-----------------------------------------------------------------------------
--
PROCEDURE process_each_inv_item (pi_nte_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
                                ,pi_iit_ne_id  IN nm_inv_items.iit_ne_id%TYPE
                                ,pi_admin_unit IN nm_admin_units.nau_admin_unit%TYPE
                                );
--
-----------------------------------------------------------------------------
--
PROCEDURE create_point_temp_ne (pi_nte_job_id_all_points       IN     nm_nw_temp_extents.nte_job_id%TYPE
                               ,pi_nte_job_id_linear           IN     nm_nw_temp_extents.nte_job_id%TYPE
                               ,po_nte_job_id_points_in_linear    OUT nm_nw_temp_extents.nte_job_id%TYPE
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
PROCEDURE update_admin_unit (pi_nte_job_id     IN nm_nw_temp_extents.nte_job_id%TYPE
                            ,pi_admin_type     IN nm_au_types.nat_admin_type%TYPE
                            ,pi_admin_unit     IN nm_admin_units.nau_admin_unit%TYPE
                            ,pi_effective_date IN date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                            ) IS
--
   l_admin_type            nm_au_types.nat_admin_type%TYPE;
--
   l_tab_affected_inv      nm3type.tab_number;
   l_tab_future_inv        nm3type.tab_number;
--
   -- Take the initial values of the things i want to set and then reset
   c_ausec_status CONSTANT varchar2(3) := nm3ausec.get_status;
   c_eff_date     CONSTANT date        := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   c_suppress     CONSTANT boolean     := nm3invval.g_suppress_hierarchy_trigger;
--
   l_rec_iig               nm_inv_item_groupings%ROWTYPE;
--
   l_tab_iig_top_id        nm3type.tab_number;
   l_tab_iig_item_id       nm3type.tab_number;
   l_tab_iig_parent_id     nm3type.tab_number;
   l_tab_iig_start_date    nm3type.tab_date;
   l_tab_iig_end_date      nm3type.tab_date;
--
   PROCEDURE reset_for_return IS
   BEGIN
      nm3ausec.set_status        (c_ausec_status);
      nm3user.set_effective_date (c_eff_date);
      nm3invval.g_suppress_hierarchy_trigger := c_suppress;
      nm3inv_xattr.activate_xattr_validation;
   END reset_for_return;
--
BEGIN
--   nm3dbg.putln(g_package_name||'.update_admin_unit('
--     ||'pi_nte_job_id='||pi_nte_job_id
--     ||', pi_admin_type='||pi_admin_type
--     ||', pi_admin_unit='||pi_admin_unit
--     ||', pi_effective_date='||pi_effective_date
--     ||')');
--   nm3dbg.ind;
--
   -- Set the effective date
   nm3user.set_effective_date (pi_effective_date);
   nm3ausec.set_status (nm3type.c_off);
   nm3invval.g_suppress_hierarchy_trigger := TRUE;
   nm3inv_xattr.deactivate_xattr_validation;
--
   g_tab_rec_parent.DELETE;
   g_tab_ne_id.DELETE;
   g_tab_rec_iig.DELETE;
--
   l_admin_type := nm3ausec.get_au_type (pi_admin_unit);
--   nm3dbg.putln('l_admin_type='||l_admin_type);
   IF l_admin_type != pi_admin_type
    THEN
      hig.raise_ner (pi_appl                => nm3type.c_net
                    ,pi_id                  => 237
                    ,pi_supplementary_info  => l_admin_type||' != '||pi_admin_type
                    );
   END IF;
--
   l_tab_future_inv   := nm3inv_extent.get_future_inv_au_type_temp_ne (pi_nte_job_id,pi_admin_type);
--
   IF l_tab_future_inv.COUNT != 0
    THEN
      hig.raise_ner (nm3type.c_net,250);
   END IF;
--
   l_tab_affected_inv := nm3inv_extent.get_inv_of_au_type_in_nte (pi_nte_job_id,pi_admin_type);
--
   FOR i IN 1..l_tab_affected_inv.COUNT
    LOOP
--
      process_each_inv_item (pi_nte_job_id => pi_nte_job_id
                            ,pi_iit_ne_id  => l_tab_affected_inv(i)
                            ,pi_admin_unit => pi_admin_unit
                            );
--
   END LOOP;
   
FORALL i in 1..l_tab_affected_inv.count
     update nm_inv_items
     set iit_end_date = pi_effective_date
     where iit_ne_id = l_tab_affected_inv(i);   
--    nm3dbg.putln('g_tab_rec_iig.count='||g_tab_rec_iig.count);
--
   FOR i IN 1..g_tab_rec_iig.COUNT
    LOOP
      DECLARE
         PROCEDURE change_ (p_val IN OUT number) IS
         BEGIN
            IF g_tab_ne_id.EXISTS(p_val)
             THEN
               p_val := g_tab_ne_id(p_val);
            END IF;
         END change_;
      BEGIN
         l_rec_iig                := g_tab_rec_iig(i);
         change_ (l_rec_iig.iig_top_id);
         change_ (l_rec_iig.iig_item_id);
         change_ (l_rec_iig.iig_parent_id);
         l_rec_iig.iig_start_date := pi_effective_date;
         l_tab_iig_top_id(i)      := l_rec_iig.iig_top_id;
         l_tab_iig_item_id(i)     := l_rec_iig.iig_item_id;
         l_tab_iig_parent_id(i)   := l_rec_iig.iig_parent_id;
         l_tab_iig_start_date(i)  := l_rec_iig.iig_start_date;
         l_tab_iig_end_date(i)    := l_rec_iig.iig_end_date;
      END;
   END LOOP;
--
--   nm3dbg.putln('l_tab_iig_top_id.count='||l_tab_iig_top_id.count);
   FORALL i IN 1..l_tab_iig_top_id.COUNT
      INSERT INTO nm_inv_item_groupings
            (iig_top_id
            ,iig_item_id
            ,iig_parent_id
            ,iig_start_date
            ,iig_end_date
            )
      SELECT l_tab_iig_top_id(i)
            ,l_tab_iig_item_id(i)
            ,l_tab_iig_parent_id(i)
            ,l_tab_iig_start_date(i)
            ,l_tab_iig_end_date(i)
       FROM  dual
      WHERE  NOT EXISTS (SELECT 1
                          FROM  nm_inv_item_groupings_all
                         WHERE  iig_top_id     = l_tab_iig_top_id(i)
                          AND   iig_item_id    = l_tab_iig_item_id(i)
                        )
       AND   NOT EXISTS (SELECT 1
                          FROM  nm_inv_item_groupings_all
                         WHERE  iig_item_id    = l_tab_iig_item_id(i)
                          AND   iig_parent_id  = l_tab_iig_parent_id(i)
                        );
                        
--  raise zero_divide;
--
   -- Reset the data for return
   reset_for_return;
--
--   nm3dbg.deind;
exception
  when others then
--     nm3dbg.puterr(sqlerrm||': '||g_package_name||'.update_admin_unit('
--       ||'pi_nte_job_id='||pi_nte_job_id
--       ||', pi_admin_type='||pi_admin_type
--       ||', pi_admin_unit='||pi_admin_unit
--       ||', pi_effective_date='||pi_effective_date
--       ||', l_admin_type='||l_admin_type
--       ||', l_tab_future_inv.count='||l_tab_future_inv.count
--       ||', l_tab_affected_inv.count='||l_tab_affected_inv.count
--       ||', g_tab_rec_iig.count='||g_tab_rec_iig.count
--       ||')');
    reset_for_return;
    raise;
    
END;
--
-----------------------------------------------------------------------------
--

PROCEDURE process_each_inv_item (pi_nte_job_id IN nm_nw_temp_extents.nte_job_id%TYPE
                                ,pi_iit_ne_id  IN nm_inv_items.iit_ne_id%TYPE
                                ,pi_admin_unit IN nm_admin_units.nau_admin_unit%TYPE
                                ) IS
--
   CURSOR cs_nte_count     (c_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE) IS
   SELECT COUNT(1)
    FROM  nm_nw_temp_extents
   WHERE  nte_job_id = c_nte_job_id;
--
   CURSOR cs_check_future  (c_iit_ne_id nm_inv_items.iit_ne_id%TYPE
                           ,c_eff_date  date
                           ) IS
   SELECT 1
    FROM  nm_members_all
   WHERE  nm_ne_id_in   = c_iit_ne_id
    AND   nm_start_date > c_eff_date;
--
   CURSOR cs_all_groupings (c_iit_ne_id nm_inv_items.iit_ne_id%TYPE) IS
   SELECT *
    FROM  nm_inv_item_groupings
   WHERE  iig_top_id    = c_iit_ne_id
   UNION
   SELECT *
    FROM  nm_inv_item_groupings
   WHERE  iig_parent_id = c_iit_ne_id
   UNION
   SELECT *
    FROM  nm_inv_item_groupings
   WHERE  iig_item_id   = c_iit_ne_id;
--
   l_dummy                   pls_integer;
   l_count                   pls_integer;
--
   l_rec_iit                 nm_inv_items%ROWTYPE;
--
   l_inv_nte_job_id          nm_nw_temp_extents.nte_job_id%TYPE;
   l_new_inv_loc_nte_job_id  nm_nw_temp_extents.nte_job_id%TYPE;
--   l_old_inv_loc_nte_job_id   nm_nw_temp_extents.nte_job_id%type;
--
   l_warning_code            varchar2(200);
   l_warning_msg             varchar2(200);
   l_check_for_inv           boolean;
--
   c_effective_date CONSTANT date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
--
   l_rec_nit                 nm_inv_types%ROWTYPE;
--
   l_rec_parent              rec_parent;
--
   l_call_homo               boolean;
--
   l_is_point_item           BOOLEAN;
--
BEGIN
--   nm3dbg.putln(g_package_name||'.process_each_inv_item('
--     ||'pi_nte_job_id='||pi_nte_job_id
--     ||', pi_iit_ne_id='||pi_iit_ne_id
--     ||', pi_admin_unit='||pi_admin_unit
--     ||')');
--   nm3dbg.ind;

  
   OPEN  cs_check_future (pi_iit_ne_id, c_effective_date);
   FETCH cs_check_future INTO l_dummy;
   IF cs_check_future%FOUND
    THEN
      CLOSE cs_check_future;
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 250
                    );
   END IF;
   CLOSE cs_check_future;
--
   -- Get the inventory record
   l_rec_iit := nm3inv.get_inv_item (pi_iit_ne_id);
--  nm3dbg.putln('l_rec_iit.iit_inv_type='||l_rec_iit.iit_inv_type);
  
--    IF l_rec_iit.iit_inv_type='ARBE'
--     THEN
--       nm_debug.set_level(3);
--    ELSE
--       nm_debug.set_level(2);
--    END IF;
   
--
   IF  l_rec_iit.iit_inv_type IS NULL     -- No READONLY access
    OR NOT invsec.is_inv_item_updatable (p_iit_inv_type   => l_rec_iit.iit_inv_type
                                        ,p_iit_admin_unit => l_rec_iit.iit_admin_unit
                                        ) -- No NORMAL access
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 267
                    ,pi_supplementary_info => l_rec_iit.iit_inv_type||' '||nm3net.get_nau(l_rec_iit.iit_admin_unit).nau_unit_code
                    );
   END IF;
--
   l_rec_nit       := nm3inv.get_inv_type (l_rec_iit.iit_inv_type);
   l_is_point_item := (l_rec_nit.nit_pnt_or_cont='P');
--
   l_rec_iit.iit_admin_unit := pi_admin_unit;
   l_rec_iit.iit_start_date := c_effective_date;
--
   l_rec_iit.iit_ne_id       := nm3net.get_next_ne_id;
   g_tab_ne_id(pi_iit_ne_id) := l_rec_iit.iit_ne_id;
--
   FOR cs_rec IN cs_all_groupings (pi_iit_ne_id)
    LOOP
      g_tab_rec_iig(g_tab_rec_iig.COUNT+1) := cs_rec;
   END LOOP;
--
   IF nm3inv.get_inv_type_attr(l_rec_iit.iit_inv_type,'IIT_PRIMARY_KEY').ita_inv_type IS NOT NULL
    AND (NOT nm3flx.is_numeric(l_rec_iit.iit_primary_key)
         OR l_rec_iit.iit_primary_key != pi_iit_ne_id
        )
    THEN
      l_check_for_inv := TRUE;
   ELSE
      l_check_for_inv := FALSE;
      l_rec_iit.iit_primary_key  := l_rec_iit.iit_ne_id;
   END IF;
--
--   nm_debug.debug('pi_nte_job_id');
--   nm3extent.debug_temp_extents(pi_nte_job_id);
--   nm3dbg.putln('nm3extent.create_temp_ne('
--      ||'pi_source_id='||pi_iit_ne_id
--      ||', pi_source='||nm3extent.c_route
--      ||')');
   nm3extent.create_temp_ne (pi_source_id => pi_iit_ne_id
                            ,pi_source    => nm3extent.c_route
                            ,po_job_id    => l_inv_nte_job_id
                            );
--   nm3dbg.putln('  l_inv_nte_job_id='||l_inv_nte_job_id);
--   nm3extent.debug_temp_extents(l_inv_nte_job_id);
   
--
   IF l_is_point_item
    THEN
      --
      -- Point items must be treated differently
      --
      create_point_temp_ne (pi_nte_job_id_all_points       => l_inv_nte_job_id
                           ,pi_nte_job_id_linear           => pi_nte_job_id
                           ,po_nte_job_id_points_in_linear => l_new_inv_loc_nte_job_id
                           );
      
   ELSE
-- PT continuous items fix: the new extent is wrong here.
--     nm3dbg.putln('nm3extent.create_temp_ne_intx_of_temp_ne('
--        ||'pi_nte_job_id_1='||pi_nte_job_id
--        ||', pi_nte_job_id_2='||l_inv_nte_job_id
--        ||')');
        
      -- PT the nm3extent.create_temp_ne_intx_of_temp_ne() creates the minus intersect where the two don't overlap
      --  we create the overlapping union intersect manually here
      select nte_id_seq.nextval into l_new_inv_loc_nte_job_id from dual;
--      nm3dbg.putln('  l_new_inv_loc_nte_job_id='||l_new_inv_loc_nte_job_id);
      
      insert into nm_nw_temp_extents (
        nte_job_id, nte_ne_id_of, nte_begin_mp, nte_end_mp, nte_cardinality, nte_seq_no, nte_route_ne_id
      )
      select *
      from (
      select
        l_new_inv_loc_nte_job_id
       ,e.nte_ne_id_of
       ,greatest(e.nte_begin_mp, e2.nte_begin_mp) nte_begin_mp
       ,least(e.nte_end_mp, e2.nte_end_mp) nte_end_mp
       ,e.nte_cardinality
       ,e.nte_seq_no
       ,e.nte_route_ne_id
      from
         nm_nw_temp_extents e
        ,nm_nw_temp_extents e2
      where e.nte_job_id = pi_nte_job_id
        and e2.nte_job_id = l_inv_nte_job_id
        and e.nte_ne_id_of = e2.nte_ne_id_of
      )
      where nte_begin_mp < nte_end_mp;
--      nm3dbg.putln('  l_new_inv_loc_nte_job_id rowcount='||sql%rowcount);
        
--       nm3extent.create_temp_ne_intx_of_temp_ne
--                        (pi_nte_job_id_1         => pi_nte_job_id
--                        ,pi_nte_job_id_2         => l_inv_nte_job_id
--                        ,pi_resultant_nte_job_id => l_new_inv_loc_nte_job_id
--                        );            
--      nm3dbg.putln('  l_new_inv_loc_nte_job_id='||l_new_inv_loc_nte_job_id);
--      l_new_inv_loc_nte_job_id := l_inv_nte_job_id;
   END IF;
    
--   nm_debug.debug('l_new_inv_loc_nte_job_id');
--   nm3extent.debug_temp_extents(l_new_inv_loc_nte_job_id);
--
   l_rec_parent.old_iit_ne_id       := pi_iit_ne_id;
   l_rec_parent.new_iit_ne_id       := l_rec_iit.iit_ne_id;
--    nm3dbg.putln('l_rec_parent.old_iit_ne_id='||l_rec_parent.old_iit_ne_id
--     ||'l_rec_parent.new_iit_ne_id='||l_rec_parent.new_iit_ne_id);
   
   FOR cs_rec IN (SELECT *
                   FROM  nm_inv_item_groupings
                  WHERE  iig_parent_id = pi_iit_ne_id
                 )
    LOOP
      l_rec_parent.old_child_iit_ne_id     := cs_rec.iig_item_id;
      g_tab_rec_parent(cs_rec.iig_item_id) := l_rec_parent;
   END LOOP;
   
--   nm3dbg.putln('nm3homo.end_inv_location_by_temp_ne('
--      ||'pi_iit_ne_id='||pi_iit_ne_id
--      ||', l_new_inv_loc_nte_job_id='||l_new_inv_loc_nte_job_id
--      ||')');
--   nm3extent.debug_temp_extents(l_new_inv_loc_nte_job_id);

--     nm3dbg.putln('nm3extent.end_inv_location_by_temp_ne('
--        ||'pi_iit_ne_id='||pi_iit_ne_id
--        ||', pi_nte_job_id='||l_new_inv_loc_nte_job_id
--        ||')');
   nm3homo.end_inv_location_by_temp_ne
                    (pi_iit_ne_id            => pi_iit_ne_id
                    ,pi_nte_job_id           => l_new_inv_loc_nte_job_id
                    ,pi_check_for_parent     => FALSE
                    ,pi_ignore_item_loc_mand => TRUE
                    ,pi_leave_child_items    => TRUE
                    ,po_warning_code         => l_warning_code
                    ,po_warning_msg          => l_warning_msg
                    );  
          
--
   IF l_rec_nit.nit_pnt_or_cont = 'C'
    THEN
      -- Get rid of any single points which may hve
      --  been left for continuous items
      DELETE FROM nm_nw_temp_extents
      WHERE  nte_job_id   = l_new_inv_loc_nte_job_id
       AND   nte_begin_mp = nte_end_mp;
   END IF;
--
   OPEN  cs_nte_count (l_new_inv_loc_nte_job_id);
   FETCH cs_nte_count INTO l_count;
   CLOSE cs_nte_count;
   
--    nm3dbg.putln('l_count='||l_count);
--
   IF l_count > 0
    THEN
    --
      IF l_check_for_inv
       THEN
         DECLARE
            CURSOR cs_exists (c_iit_ne_id number) IS
            SELECT iit_inv_type
                  ,iit_primary_key
             FROM  nm_inv_items
            WHERE  iit_ne_id = c_iit_ne_id;
            l_exists_rt cs_exists%ROWTYPE;
         BEGIN
            OPEN  cs_exists (pi_iit_ne_id);
            FETCH cs_exists INTO l_exists_rt;
            IF cs_exists%FOUND
             THEN
               CLOSE cs_exists;
               hig.raise_ner(pi_appl               => nm3type.c_net
                            ,pi_id                 => 251
                            ,pi_supplementary_info => l_exists_rt.iit_inv_type||':'||l_exists_rt.iit_primary_key
                            );
            END IF;
            CLOSE cs_exists;
         END;
      END IF;
    --
      --
      l_call_homo := TRUE;
      IF g_tab_rec_parent.EXISTS(pi_iit_ne_id)
       THEN
         DECLARE
            l_parent_iit nm_inv_items%ROWTYPE;
         BEGIN
            l_parent_iit              := nm3inv.get_inv_item(g_tab_rec_parent(pi_iit_ne_id).new_iit_ne_id);
            l_rec_iit.iit_foreign_key := l_parent_iit.iit_primary_key;
         END;
      END IF;
--      nm_debug.debug('........... recreating '||l_rec_iit.iit_inv_type||' '||pi_iit_ne_id||' as '||l_rec_iit.iit_ne_id||'('||l_rec_iit.iit_primary_key||')');
      -- Create the new inventory record
      
--       nm3dbg.putln('nm3inv.insert_nm_inv_items('
--         ||'l_rec_iit(iit_ne_id='||l_rec_iit.iit_ne_id||'))');
      
      nm3inv.insert_nm_inv_items (l_rec_iit);
      if l_rec_nit.nit_use_xy = 'N' then
      --
        DECLARE
           l_pl_arr nm_placement_array := nm3pla.initialise_placement_array;
        BEGIN
           l_pl_arr := nm3pla.get_placement_from_temp_ne (l_new_inv_loc_nte_job_id);
         
           l_pl_arr := nm3pla.get_placement_from_temp_ne (l_new_inv_loc_nte_job_id);
         
--          nm3dbg.putln('nm3homo_o.relocate_inv_at_pl('
--             ||'p_nm_ne_id_in='||l_rec_iit.iit_ne_id
--             ||', p_placement_array.count='||l_pl_arr.npa_placement_array.count
--             ||')');
           nm3homo_o.relocate_inv_at_pl (p_nm_ne_id_in     => l_rec_iit.iit_ne_id
                                        ,p_placement_array => l_pl_arr
                                        ,p_effective_date  => c_effective_date
                                        );
        END;
     END IF;
   END IF;
--
--    DELETE FROM nm_nw_temp_extents
--    WHERE  nte_job_id IN (l_inv_nte_job_id,l_new_inv_loc_nte_job_id);
--

--   nm3dbg.deind;
-- exception
--   when others then
--     nm3dbg.puterr(sqlerrm||': '||g_package_name||'.process_each_inv_item('
--       ||'pi_nte_job_id='||pi_nte_job_id
--       ||', pi_iit_ne_id='||pi_iit_ne_id
--       ||', pi_admin_unit='||pi_admin_unit
--       ||', l_rec_iit.iit_inv_type='||l_rec_iit.iit_inv_type
--       ||', l_is_point_item='||nm3dbg.to_char(l_is_point_item)
--       ||', l_rec_iit.iit_ne_id='||l_rec_iit.iit_ne_id
--       ||', l_check_for_inv='||nm3dbg.to_char(l_check_for_inv)
--       ||', l_inv_nte_job_id='||l_inv_nte_job_id
--       ||', l_new_inv_loc_nte_job_id='||l_new_inv_loc_nte_job_id
--       ||', l_rec_parent.old_iit_ne_id='||l_rec_parent.old_iit_ne_id
--       ||', l_rec_parent.new_iit_ne_id='||l_rec_parent.new_iit_ne_id
--       ||', l_rec_nit.nit_pnt_or_cont='||l_rec_nit.nit_pnt_or_cont
--       ||', l_call_homo='||nm3dbg.to_char(l_call_homo)
--       ||')');
--     raise;
--
END process_each_inv_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_point_temp_ne (pi_nte_job_id_all_points       IN     nm_nw_temp_extents.nte_job_id%TYPE
                               ,pi_nte_job_id_linear           IN     nm_nw_temp_extents.nte_job_id%TYPE
                               ,po_nte_job_id_points_in_linear    OUT nm_nw_temp_extents.nte_job_id%TYPE
                               ) IS
BEGIN
--   nm3dbg.putln(g_package_name||'.create_point_temp_ne('
--     ||'pi_nte_job_id_all_points='||pi_nte_job_id_all_points
--     ||', pi_nte_job_id_linear='||pi_nte_job_id_linear
--     ||')');
--   nm3dbg.ind;
--
   po_nte_job_id_points_in_linear := nm3net.get_next_nte_id;
--
   INSERT INTO nm_nw_temp_extents
         (nte_job_id
         ,nte_ne_id_of
         ,nte_begin_mp
         ,nte_end_mp
         ,nte_cardinality
         ,nte_seq_no
         ,nte_route_ne_id
         )
   SELECT po_nte_job_id_points_in_linear
         ,nte_pt.nte_ne_id_of
         ,nte_pt.nte_begin_mp
         ,nte_pt.nte_end_mp
         ,nte_pt.nte_cardinality
         ,nte_pt.nte_seq_no
         ,nte_pt.nte_route_ne_id
    FROM  nm_nw_temp_extents nte_pt
   WHERE  nte_pt.nte_job_id = pi_nte_job_id_all_points
    AND   EXISTS (SELECT 1
                   FROM  nm_nw_temp_extents nte_lin
                  WHERE  nte_lin.nte_job_id  = pi_nte_job_id_linear
                   AND   nte_pt.nte_ne_id_of = nte_lin.nte_ne_id_of
                   AND   nte_pt.nte_begin_mp BETWEEN nte_lin.nte_begin_mp AND nte_lin.nte_end_mp
                 );
--   nm3dbg.putln('nm_nw_temp_extents insert count: '||sql%rowcount);
--   nm3dbg.putln('po_nte_job_id_points_in_linear='||po_nte_job_id_points_in_linear);
--   nm3dbg.deind;

END create_point_temp_ne;
--
-----------------------------------------------------------------------------
--
END nm3ausec_maint;
/
