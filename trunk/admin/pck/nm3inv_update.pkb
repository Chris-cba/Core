CREATE OR REPLACE PACKAGE BODY nm3inv_update AS
--
-------------------------------------------------------------------------
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_update.pkb-arc   2.6   May 16 2011 14:44:56   Steve.Cooper  $
--       Module Name      : $Workfile:   nm3inv_update.pkb  $
--       Date into PVCS   : $Date:   May 16 2011 14:44:56  $
--       Date fetched Out : $Modtime:   Apr 01 2011 13:29:56  $
--       Version          : $Revision:   2.6  $
--       Based on SCCS version : 1.5 
-------------------------------------------------------------------------
--   Author : Kevin Angus
--
--   nm3inv_update body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here

  -----------
  --constants
  -----------
  --g_body_sccsid is the SCCS ID for the package body
  --g_body_sccsid  CONSTANT varchar2(2000) := '"@(#)nm3inv_update.pkb	1.5 04/27/06"';
  g_body_sccsid  CONSTANT varchar2(2000) := '"$Revision:   2.6  $"';

  g_package_name CONSTANT varchar2(30) := 'nm3inv_update';

  c_nl           CONSTANT varchar2(1)  := CHR(10);

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
PROCEDURE do_update_over_intx(pi_old_iit_ne_id  IN nm_inv_items.iit_ne_id%TYPE
                             ,pi_new_iit_rec    IN nm_inv_items%ROWTYPE
                             ,pi_roi_nte_id     IN nm_nw_temp_extents.nte_job_id%TYPE
                             ,pi_effective_date IN date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                             ) IS

  l_orig_loc_nte_id nm_nw_temp_extents.nte_job_id%TYPE;
  l_intx_job_id     nm_nw_temp_extents.nte_job_id%TYPE;

  l_warning_code nm3type.max_varchar2;
  l_warning_msg  nm3type.max_varchar2;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'do_update_over_intx');

  --get item location
  nm3extent.create_temp_ne(pi_source_id => pi_old_iit_ne_id
                          ,pi_source    => nm3extent.c_route  --also works with inv
                          ,po_job_id    => l_orig_loc_nte_id);

  --get intx with roi
  nm3extent.create_temp_ne_intx_of_temp_ne(pi_nte_job_id_1         => l_orig_loc_nte_id
                                          ,pi_nte_job_id_2         => pi_roi_nte_id
                                          ,pi_resultant_nte_job_id => l_intx_job_id);

  --do copy to intx
  nm3inv_copy.copy_item(pi_old_iit_ne_id  => pi_old_iit_ne_id
                       ,pi_new_rec_iit    => pi_new_iit_rec
                       ,pi_nte_job_id     => l_intx_job_id
                       ,pi_effective_date => pi_effective_date);

  DECLARE
    e_generic_error EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_generic_error, -20000);
    e_homo_not_found_item EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_homo_not_found_item, -20502);
  BEGIN
    --end old location over intx
    nm3homo.end_inv_location_by_temp_ne(pi_iit_ne_id            => pi_old_iit_ne_id
                                       ,pi_nte_job_id           => l_intx_job_id
                                       ,pi_effective_date       => pi_effective_date
                                       ,pi_ignore_item_loc_mand => TRUE
                                       ,po_warning_code         => l_warning_code
                                       ,po_warning_msg          => l_warning_msg);
  EXCEPTION
    WHEN e_homo_not_found_item
     THEN
       Null;
    WHEN e_generic_error
     THEN
       IF NOT(hig.check_last_ner(pi_appl => nm3type.c_hig
                                ,pi_id   => 67))
        THEN
          RAISE;
       END IF;

  END;

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'do_update_over_intx');

END do_update_over_intx;
--
-----------------------------------------------------------------------------
--
PROCEDURE date_tracked_all_types(pi_inv_type       IN nm_inv_types.nit_inv_type%TYPE
                                ,pi_roi_nte_id     IN nm_nw_temp_extents.nte_job_id%TYPE
                                ,pi_attrib         IN nm_inv_type_attribs.ita_attrib_name%TYPE DEFAULT NULL
                                ,pi_new_val_type   IN varchar2 DEFAULT NULL
                                ,pi_new_val_char   IN varchar2 DEFAULT NULL
                                ,pi_new_val_num    IN number DEFAULT NULL
                                ,pi_new_val_date   IN date DEFAULT NULL
                                ,pi_effective_date IN date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                                ) IS

  e_invalid_val_type EXCEPTION;

  c_init_eff_date CONSTANT date := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');

  c_attrib_plsql  CONSTANT nm3type.max_varchar2 :=            'BEGIN'
                                                   || c_nl || '  ' || g_package_name || '.g_iit_rec.' || pi_attrib || ' := :p_new_val;'
                                                   || c_nl || 'END;';

  l_items_tab nm3type.tab_number;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'date_tracked_all_types');

  nm3user.set_effective_date(p_date => pi_effective_date);

  --------------------
  --get relevant items
  --------------------
  l_items_tab := nm3inv_extent.get_inv_of_type_in_nte(pi_inv_type   => pi_inv_type
                                                     ,pi_nte_job_id => pi_roi_nte_id);

  FOR l_i IN 1..l_items_tab.COUNT
  LOOP
    g_iit_rec := nm3inv.get_inv_item(pi_ne_id => l_items_tab(l_i));

    g_iit_rec.iit_ne_id       := nm3net.get_next_ne_id;
-- assigning primary key to null brakes any inventory hierarchy
--    g_iit_rec.iit_primary_key := NULL;
    g_iit_rec.iit_primary_key := g_iit_rec.iit_ne_id;
    g_iit_rec.iit_start_date  := pi_effective_date;

    -------------------------
    --set attrib to new value
    -------------------------
    IF pi_new_val_type IS NOT NULL
    THEN
      IF pi_new_val_type = nm3type.c_number
      THEN
        EXECUTE IMMEDIATE c_attrib_plsql USING pi_new_val_num;

      ELSIF pi_new_val_type = nm3type.c_varchar
      THEN
        EXECUTE IMMEDIATE c_attrib_plsql USING pi_new_val_char;

      ELSIF pi_new_val_type = nm3type.c_date
      THEN
        EXECUTE IMMEDIATE c_attrib_plsql USING pi_new_val_date;

      ELSE
        RAISE e_invalid_val_type;
      END IF;
    END IF;

    -----------
    --do update
    -----------
    do_update_over_intx(pi_old_iit_ne_id  => l_items_tab(l_i)
                       ,pi_new_iit_rec    => g_iit_rec
                       ,pi_roi_nte_id     => pi_roi_nte_id
                       ,pi_effective_date => pi_effective_date);
  END LOOP;

  nm3user.set_effective_date(p_date => c_init_eff_date);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'date_tracked_all_types');

EXCEPTION
  WHEN e_invalid_val_type
  THEN
    nm3user.set_effective_date(p_date => c_init_eff_date);

    hig.raise_ner(pi_appl               => nm3type.c_net
                 ,pi_id                 => 28
                 ,pi_supplementary_info => 'Invalid parameter - date_tracked_all_types.pi_new_val_type = ' || pi_new_val_type);
--
  WHEN others
  THEN
    nm3user.set_effective_date(p_date => c_init_eff_date);

    RAISE;

END date_tracked_all_types;
--
-----------------------------------------------------------------------------
--
PROCEDURE date_tracked(pi_inv_type       IN nm_inv_types.nit_inv_type%TYPE
                      ,pi_roi_nte_id     IN nm_nw_temp_extents.nte_job_id%TYPE
                      ,pi_effective_date IN date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'date_tracked');

  date_tracked_all_types(pi_inv_type       => pi_inv_type
                        ,pi_roi_nte_id     => pi_roi_nte_id
                        ,pi_effective_date => pi_effective_date);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'date_tracked');

END date_tracked;
--
-----------------------------------------------------------------------------
--
PROCEDURE date_tracked(pi_inv_type       IN nm_inv_types.nit_inv_type%TYPE
                      ,pi_roi_npe_id     IN nm_nw_persistent_extents.npe_job_id%TYPE
                      ,pi_effective_date IN date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'date_tracked');

  date_tracked(pi_inv_type       => pi_inv_type
              ,pi_roi_nte_id     => nm3extent.create_nte_from_npe(pi_npe_job_id => pi_roi_npe_id)
              ,pi_effective_date => pi_effective_date);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'date_tracked');

END date_tracked;
--
-----------------------------------------------------------------------------
--
PROCEDURE date_tracked(pi_inv_type       IN nm_inv_types.nit_inv_type%TYPE
                      ,pi_roi_nte_id     IN nm_nw_temp_extents.nte_job_id%TYPE
                      ,pi_attrib         IN nm_inv_type_attribs.ita_attrib_name%TYPE
                      ,pi_new_val        IN varchar2
                      ,pi_effective_date IN date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'date_tracked');

  date_tracked_all_types(pi_inv_type       => pi_inv_type
                        ,pi_roi_nte_id     => pi_roi_nte_id
                        ,pi_attrib         => pi_attrib
                        ,pi_new_val_type   => nm3type.c_varchar
                        ,pi_new_val_char   => pi_new_val
                        ,pi_effective_date => pi_effective_date);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'date_tracked');

END date_tracked;
--
-----------------------------------------------------------------------------
--
PROCEDURE date_tracked(pi_inv_type       IN nm_inv_types.nit_inv_type%TYPE
                      ,pi_roi_npe_id     IN nm_nw_persistent_extents.npe_job_id%TYPE
                      ,pi_attrib         IN nm_inv_type_attribs.ita_attrib_name%TYPE
                      ,pi_new_val        IN varchar2
                      ,pi_effective_date IN date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'date_tracked');

  date_tracked(pi_inv_type       => pi_inv_type
              ,pi_roi_nte_id     => nm3extent.create_nte_from_npe(pi_npe_job_id => pi_roi_npe_id)
              ,pi_attrib         => pi_attrib
              ,pi_new_val        => pi_new_val
              ,pi_effective_date => pi_effective_date);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'date_tracked');

END date_tracked;
--
-----------------------------------------------------------------------------
--
PROCEDURE date_tracked(pi_inv_type       IN nm_inv_types.nit_inv_type%TYPE
                      ,pi_roi_nte_id     IN nm_nw_temp_extents.nte_job_id%TYPE
                      ,pi_attrib         IN nm_inv_type_attribs.ita_attrib_name%TYPE
                      ,pi_new_val        IN number
                      ,pi_effective_date IN date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'date_tracked');

  date_tracked_all_types(pi_inv_type       => pi_inv_type
                        ,pi_roi_nte_id     => pi_roi_nte_id
                        ,pi_attrib         => pi_attrib
                        ,pi_new_val_type   => nm3type.c_number
                        ,pi_new_val_num    => pi_new_val
                        ,pi_effective_date => pi_effective_date);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'date_tracked');
END date_tracked;
--
-----------------------------------------------------------------------------
--
PROCEDURE date_tracked(pi_inv_type       IN nm_inv_types.nit_inv_type%TYPE
                      ,pi_roi_npe_id     IN nm_nw_persistent_extents.npe_job_id%TYPE
                      ,pi_attrib         IN nm_inv_type_attribs.ita_attrib_name%TYPE
                      ,pi_new_val        IN number
                      ,pi_effective_date IN date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'date_tracked');

  date_tracked(pi_inv_type       => pi_inv_type
              ,pi_roi_nte_id     => nm3extent.create_nte_from_npe(pi_npe_job_id => pi_roi_npe_id)
              ,pi_attrib         => pi_attrib
              ,pi_new_val        => pi_new_val
              ,pi_effective_date => pi_effective_date);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'date_tracked');

END date_tracked;
--
-----------------------------------------------------------------------------
--
PROCEDURE date_tracked(pi_inv_type       IN nm_inv_types.nit_inv_type%TYPE
                      ,pi_roi_nte_id     IN nm_nw_temp_extents.nte_job_id%TYPE
                      ,pi_attrib         IN nm_inv_type_attribs.ita_attrib_name%TYPE
                      ,pi_new_val        IN date
                      ,pi_effective_date IN date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ) IS
  BEGIN

  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'date_tracked');

  date_tracked_all_types(pi_inv_type       => pi_inv_type
                        ,pi_roi_nte_id     => pi_roi_nte_id
                        ,pi_attrib         => pi_attrib
                        ,pi_new_val_type   => nm3type.c_date
                        ,pi_new_val_date   => pi_new_val
                        ,pi_effective_date => pi_effective_date);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'date_tracked');

END date_tracked;
--
-----------------------------------------------------------------------------
--
PROCEDURE date_tracked(pi_inv_type       IN nm_inv_types.nit_inv_type%TYPE
                      ,pi_roi_npe_id     IN nm_nw_persistent_extents.npe_job_id%TYPE
                      ,pi_attrib         IN nm_inv_type_attribs.ita_attrib_name%TYPE
                      ,pi_new_val        IN date
                      ,pi_effective_date IN date DEFAULT To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY')
                      ) IS
BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'date_tracked');

  date_tracked(pi_inv_type       => pi_inv_type
              ,pi_roi_nte_id     => nm3extent.create_nte_from_npe(pi_npe_job_id => pi_roi_npe_id)
              ,pi_attrib         => pi_attrib
              ,pi_new_val        => pi_new_val
              ,pi_effective_date => pi_effective_date);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'date_tracked');

END date_tracked;
--
-----------------------------------------------------------------------------
--
PROCEDURE date_track_update_item (pi_iit_ne_id_old IN     nm_inv_items.iit_ne_id%TYPE
                                 ,pio_rec_iit      IN OUT nm_inv_items%ROWTYPE
                                 ) IS
--
   c_init_eff_date CONSTANT DATE    := To_Date(Sys_Context('NM3CORE','EFFECTIVE_DATE'),'DD-MON-YYYY');
   c_xattr_status  CONSTANT BOOLEAN := nm3inv_xattr.g_xattr_active;
--
   l_nte_job_id             nm_nw_temp_extents.nte_job_id%TYPE;
   l_rec_iit_old            nm_inv_items%ROWTYPE;
--
   l_tab_rec_iit_child       nm3type.tab_rec_iit;
   l_tab_iit_ne_id_old nm3type.tab_number;
   l_count                   PLS_INTEGER := 0;
   l_rec_iit_child           nm_inv_items%ROWTYPE;
   l_rec_iit_child_end_dated nm_inv_items%ROWTYPE; -- LS added
--
   -- MApcapture test for larimer
   -- Commneted this code to handle the child based on the relationship
   -- LS 17/04
   /*
   CURSOR cs_children (c_iit_ne_id nm_inv_items.iit_ne_id%TYPE) IS
   SELECT iit.*
    FROM  nm_inv_items          iit
         ,nm_inv_item_groupings iig
   WHERE  iit.iit_ne_id     = iig.iig_item_id
    AND   iig.iig_parent_id = c_iit_ne_id;
--
   CURSOR cs_children_of_children (c_iit_ne_id nm_inv_items.iit_ne_id%TYPE) IS
   SELECT iit.*
    FROM  nm_inv_items          iit
   WHERE  iit.iit_ne_id     IN (SELECT iig.iig_item_id
                                 FROM  nm_inv_item_groupings iig
                                START WITH iig.iig_parent_id = c_iit_ne_id
                                CONNECT BY iig_parent_id = PRIOR iig_item_id
                               );
  */
  CURSOR  cs_child_assets(c_iit_ne_id nm_inv_items.iit_ne_id%TYPE) IS
   SELECT  level,iit.iit_ne_id
   FROM    nm_inv_item_groupings iig
          ,nm_inv_items iit
          ,nm_inv_type_groupings itg
   WHERE  iig.iig_item_id       = iit.iit_ne_id
   AND    iit.iit_inv_type      = itg.itg_inv_type
   AND    itg.itg_mandatory     = 'Y'                                    
   CONNECT By PRIOR iig_item_id = iig_parent_id
   START   WITH iig_parent_id   = c_iit_ne_id 
   ORDER BY level;

   l_iit_rec nm_inv_items%ROWTYPE ; 
--
   PROCEDURE set_for_return IS
   BEGIN
      nm3user.set_effective_date (c_init_eff_date);
      nm3inv_xattr.g_xattr_active            := c_xattr_status;
   END set_for_return;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'date_track_update_item');
--
   nm3user.set_effective_date (pio_rec_iit.iit_start_date);
--
   l_rec_iit_old := nm3get.get_iit (pi_iit_ne_id => pi_iit_ne_id_old);
--
   IF l_rec_iit_old.iit_inv_type != pio_rec_iit.iit_inv_type
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_hig
                    ,pi_id                 => 114
                    ,pi_supplementary_info => l_rec_iit_old.iit_inv_type||' != '||pio_rec_iit.iit_inv_type
                    );
   END IF;
--
   IF l_rec_iit_old.iit_start_date = pio_rec_iit.iit_start_date
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 307
                    ,pi_supplementary_info => to_char(pio_rec_iit.iit_start_date,Sys_Context('NM3CORE','USER_DATE_MASK'))
                    );
   END IF;
--
   nm3extent.create_temp_ne (pi_source_id => pi_iit_ne_id_old
                            ,pi_source    => nm3extent.c_route  --also works with inv
                            ,po_job_id    => l_nte_job_id
                            );
--
   l_tab_iit_ne_id_old(0) := pi_iit_ne_id_old;
--
   --LS 17/04
   /*
   FOR cs_rec IN cs_children (pi_iit_ne_id_old)
    LOOP
      l_iit_rec                         := nm3get.get_iit(cs_rec.iit_ne_id)
      l_count                           := l_count + 1;
      l_rec_iit_child                   := l_iit_rec;
      l_tab_iit_ne_id_old(l_count)      := l_iit_rec.iit_ne_id;
      l_rec_iit_child.iit_ne_id         := nm3net.get_next_ne_id;
      l_rec_iit_child.iit_start_date    := pio_rec_iit.iit_start_date;
      l_rec_iit_child.iit_foreign_key   := pio_rec_iit.iit_primary_key;
      l_tab_rec_iit_child(l_count)      := l_rec_iit_child;
      FOR cs_grandchild IN cs_children_of_children (cs_rec.iit_ne_id)
       LOOP
         l_count                        := l_count + 1;
         l_rec_iit_child                := cs_grandchild;
         l_tab_iit_ne_id_old(l_count)   := cs_grandchild.iit_ne_id;
         l_rec_iit_child.iit_ne_id      := nm3net.get_next_ne_id;
         l_rec_iit_child.iit_start_date := pio_rec_iit.iit_start_date;
         l_tab_rec_iit_child(l_count)   := l_rec_iit_child;
      END LOOP;
   END LOOP;
   */
   FOR cs_rec IN cs_child_assets (pi_iit_ne_id_old)
    LOOP
      l_iit_rec                         := nm3get.get_iit(cs_rec.iit_ne_id) ;
      l_count                           := l_count + 1;
      l_rec_iit_child                   := l_iit_rec;
      l_tab_iit_ne_id_old(l_count)      := l_iit_rec.iit_ne_id;
      l_rec_iit_child.iit_ne_id         := nm3net.get_next_ne_id ;                  
      l_rec_iit_child.iit_start_date    := pio_rec_iit.iit_start_date;
      l_tab_rec_iit_child(l_count)      := l_rec_iit_child;     
      l_rec_iit_child_end_dated         := l_iit_rec;
      l_rec_iit_child_end_dated.iit_start_date   := pio_rec_iit.iit_start_date;
      IF cs_rec.level =  1
      THEN
          l_rec_iit_child.iit_foreign_key           := pio_rec_iit.iit_primary_key;
          l_rec_iit_child_end_dated.iit_foreign_key := pio_rec_iit.iit_primary_key;       
      --ELSE
      --    l_rec_iit_child.iit_foreign_key            := l_iit_rec.iit_primary_key;
      --    l_rec_iit_child_end_dated.iit_foreign_key  := l_iit_rec.iit_primary_key;
      END IF ;
      nm3mapcapture_ins_inv.l_iit_tab(nm3mapcapture_ins_inv.l_iit_tab.Count+1)    := l_rec_iit_child_end_dated; --  LS Hierarchical asset changes
   END LOOP ;
   --  
--
   -- Lock all the old inventory items and their member records
   FOR i IN l_tab_iit_ne_id_old.FIRST..l_tab_iit_ne_id_old.LAST
    LOOP
      nm3lock.lock_inv_item_and_members (pi_iit_ne_id      => l_tab_iit_ne_id_old(i)
                                        ,p_lock_for_update => TRUE
                                        );
   END LOOP;
--
   nm3inv_xattr.g_xattr_active := FALSE;
   UPDATE nm_inv_items_all
    SET   iit_end_date = pio_rec_iit.iit_start_date
   WHERE  iit_ne_id    = pi_iit_ne_id_old;
   nm3inv_xattr.g_xattr_active := c_xattr_status;
--
   IF  (pio_rec_iit.iit_ne_id IS NOT NULL
        AND nm3get.get_iit_all (pi_iit_ne_id       => pio_rec_iit.iit_ne_id
                               ,pi_raise_not_found => FALSE
                               ).iit_inv_type IS NOT NULL
       )
    OR  pio_rec_iit.iit_ne_id IS NULL
    THEN
      pio_rec_iit.iit_ne_id := nm3net.get_next_ne_id;
   END IF;
--
   nm3ins.ins_iit_all  (p_rec_iit_all => pio_rec_iit);
--
   nm3homo.homo_update (p_temp_ne_id_in  => l_nte_job_id
                       ,p_iit_ne_id      => pio_rec_iit.iit_ne_id
                       ,p_effective_date => pio_rec_iit.iit_start_date
                       );
--
   -- Stopped creating of child asset when called from mapcapture
   IF Nvl(nm3mapcapture_ins_inv.l_mapcap_run,'N') = 'N'
   THEN 
       FOR i IN 1..l_tab_rec_iit_child.COUNT
       LOOP
           nm3ins.ins_iit_all  (p_rec_iit_all => l_tab_rec_iit_child(i));
       END LOOP;
   END IF ;
--
   set_for_return;
--
   nm_debug.proc_end(g_package_name,'date_track_update_item');
--
EXCEPTION
--
   WHEN others
    THEN
      set_for_return;
      RAISE;
--
END date_track_update_item;
--
-----------------------------------------------------------------------------
--
END nm3inv_update;
/
