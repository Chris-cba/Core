CREATE OR REPLACE PACKAGE BODY nm3api_inv AS
--
-----------------------------------------------------------------------------
--
--   PVCS Identifiers :-
--
--       PVCS id          : $Header:   //vm_latest/archives/nm3/admin/pck/nm3api_inv.pkb-arc   2.4.1.0   Feb 27 2012 11:26:06   Rob.Coupe  $
--       Module Name      : $Workfile:   nm3api_inv.pkb  $
--       Date into PVCS   : $Date:   Feb 27 2012 11:26:06  $
--       Date fetched Out : $Modtime:   Feb 27 2012 11:24:56  $
--       Version          : $Revision:   2.4.1.0  $
--
--   Author : Jonathan Mills
--
--   Inventory API package body
--
-----------------------------------------------------------------------------
--	Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--

  --g_body_sccsid is the SCCS ID for the package body
  g_body_sccsid  CONSTANT varchar2(2000) := '$Revision:   2.4.1.0  $';
  
--   g_body_sccsid     CONSTANT  varchar2(2000) := '"@(#)nm3api_inv.pkb	1.6 12/18/03"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  varchar2(30)   := 'nm3api_inv';
--
-----------------------------------------------------------------------------
--
PROCEDURE append_nte_to_existing_loc (p_iit_ne_id  IN     nm_inv_items.iit_ne_id%TYPE
                                     ,p_nte_job_id IN     nm_nw_temp_extents.nte_job_id%TYPE
                                     );
--
-----------------------------------------------------------------------------
--
PROCEDURE homo_update_internal (p_iit_ne_id      IN     nm_inv_items.iit_ne_id%TYPE
                               ,p_nte_job_id     IN     nm_nw_temp_extents.nte_job_id%TYPE
                               ,p_effective_date IN     date
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
--
--  Local copyof same procedure from nm3homo - as it is private and needs to be built as patch release
--
PROCEDURE check_item_has_no_future_locs (p_iit_ne_id      nm_inv_items.iit_ne_id%TYPE
                                        ,p_effective_date DATE DEFAULT nm3user.get_effective_date
                                        ) is
                                        
--
   CURSOR cs_future_locs (c_nm_ne_id_in    nm_members_all.nm_ne_id_in%TYPE
                         ,c_effective_date DATE
                         ) IS
   SELECT 1
    FROM  nm_members_all nm
   WHERE  nm_ne_id_in   = c_nm_ne_id_in
    AND   nm_start_date > c_effective_date
    AND   ROWNUM        = 1;
--
   l_dummy PLS_INTEGER;
   l_found BOOLEAN;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'check_item_has_no_future_locs');
--
   OPEN  cs_future_locs (p_iit_ne_id, p_effective_date);
   FETCH cs_future_locs INTO l_dummy;
   l_found := cs_future_locs%FOUND;
   CLOSE cs_future_locs;
--
   IF l_found
    THEN
      hig.raise_ner (pi_appl => nm3type.c_net
                    ,pi_id   => 355
                    );
   END IF;
--
   nm_debug.proc_end (g_package_name,'check_item_has_no_future_locs');
--
END check_item_has_no_future_locs;
--
                                        
-----------------------------------------------------------------------------
--
FUNCTION get_iit_ne_id (p_iit_primary_key IN nm_inv_items.iit_primary_key%TYPE
                       ,p_iit_inv_type    IN nm_inv_items.iit_inv_type%TYPE
                       ,p_effective_date  IN date DEFAULT nm3user.get_effective_date
                       ) RETURN nm_inv_items.iit_ne_id%TYPE IS
--
   c_init_eff_date CONSTANT date := nm3user.get_effective_date;
   l_iit_ne_id              nm_inv_items.iit_ne_id%TYPE;
--
BEGIN
--
   BEGIN
      nm3user.set_effective_date (p_effective_date);
      l_iit_ne_id := nm3get.get_iit(pi_iit_primary_key => p_iit_primary_key
                                   ,pi_iit_inv_type    => p_iit_inv_type
                                   ).iit_ne_id;
      nm3user.set_effective_date (c_init_eff_date);
   EXCEPTION
      WHEN others
       THEN
         nm3user.set_effective_date (c_init_eff_date);
         RAISE;
   END;
--
   RETURN l_iit_ne_id;
--
END get_iit_ne_id;
--
-----------------------------------------------------------------------------
--
FUNCTION get_group_placement_for_item (p_iit_primary_key IN nm_inv_items.iit_primary_key%TYPE
                                      ,p_iit_inv_type    IN nm_inv_items.iit_inv_type%TYPE
                                      ,p_group_type      IN nm_group_types.ngt_group_type%TYPE DEFAULT nm3user.get_preferred_lrm
                                      ,p_effective_date  IN date                               DEFAULT nm3user.get_effective_date
                                      ) RETURN nm_placement_array IS
--
   c_init_eff_date CONSTANT date               := nm3user.get_effective_date;
   l_pl_arr                 nm_placement_array := nm3pla.initialise_placement_array;
   l_iit_ne_id              nm_inv_items.iit_ne_id%TYPE;
--
BEGIN
--
   BEGIN
      nm3user.set_effective_date    (p_effective_date);
      l_iit_ne_id := get_iit_ne_id  (p_iit_primary_key => p_iit_primary_key
                                    ,p_iit_inv_type    => p_iit_inv_type
                                    ,p_effective_date  => p_effective_date
                                    );
      l_pl_arr    := nm3pla.get_connected_chunks
                                    (pi_ne_id          => l_iit_ne_id
                                    ,pi_obj_type       => p_group_type
                                    );
      nm3user.set_effective_date    (c_init_eff_date);
   EXCEPTION
      WHEN others
       THEN
         nm3user.set_effective_date (c_init_eff_date);
         RAISE;
   END;
--
   RETURN l_pl_arr;
--
END get_group_placement_for_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inventory_item (p_rec_iit            IN OUT nm_inv_items%ROWTYPE
                                ,p_effective_date     IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                                ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inventory_item');
--
   p_rec_iit.iit_ne_id      := nm3net.get_next_ne_id;
   p_rec_iit.iit_start_date := p_effective_date;
--
   nm3inv.validate_rec_iit (p_rec_iit);
--
   nm3ins.ins_iit_all (p_rec_iit);
--
   nm_debug.proc_end (g_package_name,'create_inventory_item');
--
END create_inventory_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inventory_item (p_rec_iit            IN OUT nm_inv_items%ROWTYPE
                                ,p_effective_date     IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                                ,p_element_ne_unique  IN     nm_elements.ne_unique%TYPE
                                ,p_element_ne_nt_type IN     nm_elements.ne_nt_type%TYPE      DEFAULT NULL
                                ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inventory_item');
--
   create_inventory_item (p_rec_iit           => p_rec_iit
                         ,p_effective_date    => p_effective_date
                         );
--
   locate_item (p_iit_ne_id                  => p_rec_iit.iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => c_replace
               ,p_element_ne_unique          => p_element_ne_unique
               ,p_element_ne_nt_type         => p_element_ne_nt_type
               );
--
   nm_debug.proc_end (g_package_name,'create_inventory_item');
--
END create_inventory_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inventory_item (p_rec_iit            IN OUT nm_inv_items%ROWTYPE
                                ,p_effective_date     IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                                ,p_element_ne_id      IN     nm_elements.ne_id%TYPE
                                ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inventory_item');
--
   create_inventory_item (p_rec_iit           => p_rec_iit
                         ,p_effective_date    => p_effective_date
                         );
--
   locate_item (p_iit_ne_id                  => p_rec_iit.iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => c_replace
               ,p_element_ne_id              => p_element_ne_id
               );
--
   nm_debug.proc_end (g_package_name,'create_inventory_item');
--
END create_inventory_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inventory_item (p_rec_iit            IN OUT nm_inv_items%ROWTYPE
                                ,p_effective_date     IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                                ,p_element_ne_unique  IN     nm_elements.ne_unique%TYPE
                                ,p_element_ne_nt_type IN     nm_elements.ne_nt_type%TYPE      DEFAULT NULL
                                ,p_element_begin_mp   IN     nm_members.nm_begin_mp%TYPE
                                ,p_element_end_mp     IN     nm_members.nm_end_mp%TYPE        DEFAULT NULL
                                ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inventory_item');
--
   create_inventory_item (p_rec_iit           => p_rec_iit
                         ,p_effective_date    => p_effective_date
                         );
--
   locate_item (p_iit_ne_id                  => p_rec_iit.iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => c_replace
               ,p_element_ne_unique          => p_element_ne_unique
               ,p_element_ne_nt_type         => p_element_ne_nt_type
               ,p_element_begin_mp           => p_element_begin_mp
               ,p_element_end_mp             => p_element_end_mp
               );
--
   nm_debug.proc_end (g_package_name,'create_inventory_item');
--
END create_inventory_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inventory_item (p_rec_iit            IN OUT nm_inv_items%ROWTYPE
                                ,p_effective_date     IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                                ,p_element_ne_id      IN     nm_elements.ne_id%TYPE
                                ,p_element_begin_mp   IN     nm_members.nm_begin_mp%TYPE
                                ,p_element_end_mp     IN     nm_members.nm_end_mp%TYPE        DEFAULT NULL
                                ) IS
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inventory_item');
--
   create_inventory_item (p_rec_iit        => p_rec_iit
                         ,p_effective_date => p_effective_date
                         );
--
   locate_item (p_iit_ne_id                  => p_rec_iit.iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => c_replace
               ,p_element_ne_id              => p_element_ne_id
               ,p_element_begin_mp           => p_element_begin_mp
               ,p_element_end_mp             => p_element_end_mp
               );
--
   nm_debug.proc_end (g_package_name,'create_inventory_item');
--
END create_inventory_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inventory_item (p_rec_iit            IN OUT nm_inv_items%ROWTYPE
                                ,p_effective_date     IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                                ,p_nse_id             IN     nm_saved_extents.nse_id%TYPE
                                ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inventory_item');
--
   create_inventory_item (p_rec_iit        => p_rec_iit
                         ,p_effective_date => p_effective_date
                         );
--
   locate_item (p_iit_ne_id                  => p_rec_iit.iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => c_replace
               ,p_nse_id                     => p_nse_id
               );
--
   nm_debug.proc_end (g_package_name,'create_inventory_item');
--
END create_inventory_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inventory_item (p_rec_iit                 IN OUT nm_inv_items%ROWTYPE
                                ,p_effective_date          IN     date                          DEFAULT nm3user.get_effective_date
                                ,p_route_ne_id             IN     nm_elements.ne_id%TYPE        DEFAULT NULL
                                ,p_start_ne_id             IN     nm_elements.ne_id%TYPE
                                ,p_start_offset            IN     number
                                ,p_end_ne_id               IN     nm_elements.ne_id%TYPE        DEFAULT NULL
                                ,p_end_offset              IN     number                        DEFAULT NULL
                                ,p_sub_class               IN     nm_elements.ne_sub_class%TYPE DEFAULT NULL
                                ,p_restrict_excl_sub_class IN     varchar2                      DEFAULT NULL
                                ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inventory_item');
--
   create_inventory_item (p_rec_iit        => p_rec_iit
                         ,p_effective_date => p_effective_date
                         );
--
   locate_item (p_iit_ne_id                  => p_rec_iit.iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => c_replace
               ,p_route_ne_id                => p_route_ne_id
               ,p_start_ne_id                => p_start_ne_id
               ,p_start_offset               => p_start_offset
               ,p_end_ne_id                  => p_end_ne_id
               ,p_end_offset                 => p_end_offset
               ,p_sub_class                  => p_sub_class
               ,p_restrict_excl_sub_class    => p_restrict_excl_sub_class
               );
--
   nm_debug.proc_end (g_package_name,'create_inventory_item');
--
END create_inventory_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inventory_item (p_rec_iit                 IN OUT nm_inv_items%ROWTYPE
                                ,p_effective_date          IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                                ,p_pl_arr                  IN     nm_placement_array
                                ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inventory_item');
--
   create_inventory_item (p_rec_iit        => p_rec_iit
                         ,p_effective_date => p_effective_date
                         );
--
   locate_item (p_iit_ne_id                  => p_rec_iit.iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => c_replace
               ,p_pl_arr                     => p_pl_arr
               );
--
   nm_debug.proc_end (g_package_name,'create_inventory_item');
--
END create_inventory_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE create_inventory_item (p_rec_iit                 IN OUT nm_inv_items%ROWTYPE
                                ,p_effective_date          IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                                ,p_pl                      IN     nm_placement
                                ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'create_inventory_item');
--
   create_inventory_item (p_rec_iit        => p_rec_iit
                         ,p_effective_date => p_effective_date
                         );
--
   locate_item (p_iit_ne_id                  => p_rec_iit.iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => c_replace
               ,p_pl                         => p_pl
               );
--
   nm_debug.proc_end (g_package_name,'create_inventory_item');
--
END create_inventory_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_item (p_iit_ne_id                  IN     nm_inv_items.iit_ne_id%TYPE
                      ,p_effective_date             IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                      ,p_append_or_replace_existing IN varchar2 DEFAULT c_replace
                      ,p_element_ne_unique          IN     nm_elements.ne_unique%TYPE
                      ,p_element_ne_nt_type         IN     nm_elements.ne_nt_type%TYPE      DEFAULT NULL
                      ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'locate_item');
--
   locate_item (p_iit_ne_id                  => p_iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => p_append_or_replace_existing
               ,p_element_ne_unique          => p_element_ne_unique
               ,p_element_ne_nt_type         => p_element_ne_nt_type
               ,p_element_begin_mp           => NULL
               ,p_element_end_mp             => NULL
               );
--
   nm_debug.proc_end (g_package_name,'locate_item');
--
--
END locate_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_item (p_iit_ne_id                  IN     nm_inv_items.iit_ne_id%TYPE
                      ,p_effective_date             IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                      ,p_append_or_replace_existing IN     varchar2                         DEFAULT c_replace
                      ,p_element_ne_id              IN     nm_elements.ne_id%TYPE
                      ) IS
BEGIN
--
   nm_debug.proc_start (g_package_name,'locate_item');
--
   IF p_element_ne_id IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 282
                    ,pi_supplementary_info => 'p_element_ne_id'
                    );
   END IF;
--
   locate_item (p_iit_ne_id                  => p_iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => p_append_or_replace_existing
               ,p_element_ne_id              => p_element_ne_id
               ,p_element_begin_mp           => NULL
               ,p_element_end_mp             => NULL
               );
--
   nm_debug.proc_end (g_package_name,'locate_item');
--
END locate_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_item (p_iit_ne_id                  IN     nm_inv_items.iit_ne_id%TYPE
                      ,p_effective_date             IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                      ,p_append_or_replace_existing IN     varchar2                         DEFAULT c_replace
                      ,p_element_ne_unique          IN     nm_elements.ne_unique%TYPE
                      ,p_element_ne_nt_type         IN     nm_elements.ne_nt_type%TYPE      DEFAULT NULL
                      ,p_element_begin_mp           IN     nm_members.nm_begin_mp%TYPE
                      ,p_element_end_mp             IN     nm_members.nm_end_mp%TYPE        DEFAULT NULL
                      ) IS
--
   c_init_eff_date CONSTANT date := nm3user.get_effective_date;
--
   l_ne_id nm_elements.ne_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'locate_item');
--
   IF p_element_ne_unique IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 282
                    ,pi_supplementary_info => 'p_element_ne_unique'
                    );
   END IF;
--
   nm3user.set_effective_date (p_effective_date);
--
   l_ne_id := nm3net.get_ne_id (p_element_ne_unique, p_element_ne_nt_type);
--
   locate_item (p_iit_ne_id                  => p_iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => p_append_or_replace_existing
               ,p_element_ne_id              => l_ne_id
               ,p_element_begin_mp           => p_element_begin_mp
               ,p_element_end_mp             => p_element_end_mp
               );
--
   nm3user.set_effective_date (c_init_eff_date);
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_init_eff_date);
      RAISE;
--
END locate_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_item (p_iit_ne_id                  IN     nm_inv_items.iit_ne_id%TYPE
                      ,p_effective_date             IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                      ,p_append_or_replace_existing IN     varchar2                         DEFAULT c_replace
                      ,p_element_ne_id              IN     nm_elements.ne_id%TYPE
                      ,p_element_begin_mp           IN     nm_members.nm_begin_mp%TYPE
                      ,p_element_end_mp             IN     nm_members.nm_end_mp%TYPE        DEFAULT NULL
                      ) IS
--
   c_init_eff_date CONSTANT date := nm3user.get_effective_date;
--
   l_nte_job_id   nm_nw_temp_extents.nte_job_id%TYPE;
--
   l_end_mp       nm_members.nm_end_mp%TYPE := p_element_end_mp;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'locate_item');
--
   IF p_element_ne_id IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 282
                    ,pi_supplementary_info => 'p_element_ne_id'
                    );
   END IF;
--
   nm3user.set_effective_date (p_effective_date);
--
   IF nm3inv.get_inv_type (nm3inv.get_inv_type (p_iit_ne_id)).nit_pnt_or_cont = 'C'
    THEN
      IF NOT ( (p_element_begin_mp IS     NULL AND l_end_mp IS     NULL)
            OR (p_element_begin_mp IS NOT NULL AND l_end_mp IS NOT NULL)
             )
       THEN
         hig.raise_ner (nm3type.c_net,281);
      END IF;
      IF   p_element_begin_mp IS NOT NULL
       AND l_end_mp           IS NOT NULL
       THEN
         IF p_element_begin_mp = l_end_mp
          THEN
            hig.raise_ner (nm3type.c_net,86);
         ELSIF p_element_begin_mp > l_end_mp
          THEN
            hig.raise_ner (nm3type.c_net,276);
         END IF;
      END IF;
   ELSE
      IF l_end_mp IS NULL
       THEN
         l_end_mp := p_element_begin_mp;
      END IF;
      IF  p_element_begin_mp IS NULL
       OR p_element_begin_mp != l_end_mp
       THEN
         hig.raise_ner(nm3type.c_net,105);
      END IF;
   END IF;
--
   IF p_element_begin_mp = l_end_mp
    THEN
      DECLARE
         l_lref_datum  nm_lref;
         l_lref_parent nm_lref;
         l_pl          nm_placement_array;
      BEGIN
         l_lref_parent   := nm_lref(p_element_ne_id,p_element_begin_mp);
         IF nm3net.is_nt_datum(nm3net.get_nt_type (p_element_ne_id)) = 'Y'
          THEN
            l_lref_datum := l_lref_parent;
         ELSE
            l_lref_datum := nm3lrs.get_distinct_offset(l_lref_parent);
         END IF;
         l_pl            := nm3pla.initialise_placement_array (l_lref_datum.lr_ne_id
                                                              ,l_lref_datum.lr_offset
                                                              ,l_lref_datum.lr_offset
                                                              ,0
                                                              );
         nm3extent_o.create_temp_ne_from_pl (l_pl, l_nte_job_id);
      END;
   ELSE
      nm3extent.create_temp_ne (pi_source_id => p_element_ne_id
                               ,pi_source    => nm3extent.c_route
                               ,pi_begin_mp  => p_element_begin_mp
                               ,pi_end_mp    => l_end_mp
                               ,po_job_id    => l_nte_job_id
                               );
   END IF;
--
   IF p_append_or_replace_existing = c_append
    THEN
      append_nte_to_existing_loc (p_iit_ne_id  => p_iit_ne_id
                                 ,p_nte_job_id => l_nte_job_id
                                 );
   END IF;
--
   homo_update_internal (p_iit_ne_id      => p_iit_ne_id
                        ,p_nte_job_id     => l_nte_job_id
                        ,p_effective_date => p_effective_date
                        );
--
   nm3user.set_effective_date (c_init_eff_date);
--
   nm_debug.proc_end (g_package_name,'locate_item');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_init_eff_date);
      RAISE;
--
END locate_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_item (p_iit_ne_id                  IN     nm_inv_items.iit_ne_id%TYPE
                      ,p_effective_date             IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                      ,p_append_or_replace_existing IN     varchar2                         DEFAULT c_replace
                      ,p_nse_id                     IN     nm_saved_extents.nse_id%TYPE
                      ) IS
--
   c_init_eff_date CONSTANT date := nm3user.get_effective_date;
--
   l_nte_job_id   nm_nw_temp_extents.nte_job_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start (g_package_name,'locate_item');
--
   IF p_nse_id IS NULL
    THEN
      hig.raise_ner (pi_appl               => nm3type.c_net
                    ,pi_id                 => 282
                    ,pi_supplementary_info => 'p_nse_id'
                    );
   END IF;
--
   nm3user.set_effective_date (p_effective_date);
--
   nm3extent.create_temp_ne (pi_source_id => p_nse_id
                            ,pi_source    => nm3extent.c_saved
                            ,pi_begin_mp  => NULL
                            ,pi_end_mp    => NULL
                            ,po_job_id    => l_nte_job_id
                            );
--
   IF p_append_or_replace_existing = c_append
    THEN
      append_nte_to_existing_loc (p_iit_ne_id  => p_iit_ne_id
                                 ,p_nte_job_id => l_nte_job_id
                                 );
   END IF;
--
   homo_update_internal (p_iit_ne_id      => p_iit_ne_id
                        ,p_nte_job_id     => l_nte_job_id
                        ,p_effective_date => p_effective_date
                        );
--
   nm3user.set_effective_date (c_init_eff_date);
--
   nm_debug.proc_end (g_package_name,'locate_item');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_init_eff_date);
      RAISE;
--
END locate_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_item (p_iit_ne_id                  IN     nm_inv_items.iit_ne_id%TYPE
                      ,p_effective_date             IN     date                          DEFAULT nm3user.get_effective_date
                      ,p_append_or_replace_existing IN     varchar2                      DEFAULT c_replace
                      ,p_route_ne_id                IN     nm_elements.ne_id%TYPE        DEFAULT NULL
                      ,p_start_ne_id                IN     nm_elements.ne_id%TYPE
                      ,p_start_offset               IN     number
                      ,p_end_ne_id                  IN     nm_elements.ne_id%TYPE        DEFAULT NULL
                      ,p_end_offset                 IN     number                        DEFAULT NULL
                      ,p_sub_class                  IN     nm_elements.ne_sub_class%TYPE DEFAULT NULL
                      ,p_restrict_excl_sub_class    IN     varchar2                      DEFAULT NULL
                      ) IS
--
   c_init_eff_date CONSTANT date := nm3user.get_effective_date;
--
   l_nte_job_id      nm_nw_temp_extents.nte_job_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'locate_item');
--
   nm3user.set_effective_date (p_effective_date);
--
   nm3wrap.create_temp_ne_from_route (pi_route                   => p_route_ne_id
                                     ,pi_start_ne_id             => p_start_ne_id
                                     ,pi_start_offset            => p_start_offset
                                     ,pi_end_ne_id               => p_end_ne_id
                                     ,pi_end_offset              => p_end_offset
                                     ,pi_sub_class               => p_sub_class
                                     ,pi_restrict_excl_sub_class => NVL(p_restrict_excl_sub_class,'N')
                                     ,pi_homo_check              => TRUE
                                     ,po_job_id                  => l_nte_job_id
                                     );
--
   IF p_append_or_replace_existing = c_append
    THEN
      append_nte_to_existing_loc (p_iit_ne_id  => p_iit_ne_id
                                 ,p_nte_job_id => l_nte_job_id
                                 );
   END IF;
--
   homo_update_internal (p_iit_ne_id      => p_iit_ne_id
                        ,p_nte_job_id     => l_nte_job_id
                        ,p_effective_date => p_effective_date
                        );
--
   nm3user.set_effective_date (c_init_eff_date);
--
   nm_debug.proc_end(g_package_name,'locate_item');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_init_eff_date);
      RAISE;
--
END locate_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_item (p_iit_ne_id                  IN     nm_inv_items.iit_ne_id%TYPE
                      ,p_effective_date             IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                      ,p_append_or_replace_existing IN     varchar2                         DEFAULT c_replace
                      ,p_pl_arr                     IN     nm_placement_array
                      ) IS
--
   c_init_eff_date CONSTANT date := nm3user.get_effective_date;
--
   l_nte_job_id      nm_nw_temp_extents.nte_job_id%TYPE;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'locate_item');
--
   nm3user.set_effective_date (p_effective_date);
--
   nm3extent_o.create_temp_ne_from_pl (pi_pl_arr => p_pl_arr
                                      ,po_job_id => l_nte_job_id
                                      );
--
   homo_update_internal (p_iit_ne_id      => p_iit_ne_id
                        ,p_nte_job_id     => l_nte_job_id
                        ,p_effective_date => p_effective_date
                        );
--
   nm3user.set_effective_date (c_init_eff_date);
--
   nm_debug.proc_end(g_package_name,'locate_item');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_init_eff_date);
      RAISE;
--
END locate_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE locate_item (p_iit_ne_id                  IN     nm_inv_items.iit_ne_id%TYPE
                      ,p_effective_date             IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                      ,p_append_or_replace_existing IN     varchar2                         DEFAULT c_replace
                      ,p_pl                         IN     nm_placement
                      ) IS
--
   l_pl_arr nm_placement_array := nm3pla.initialise_placement_array;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'locate_item');
--
   l_pl_arr := l_pl_arr.add_element(p_pl);
--
   locate_item (p_iit_ne_id                  => p_iit_ne_id
               ,p_effective_date             => p_effective_date
               ,p_append_or_replace_existing => p_append_or_replace_existing
               ,p_pl_arr                     => l_pl_arr
               );
--
   nm_debug.proc_end(g_package_name,'locate_item');
--
END locate_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE append_nte_to_existing_loc (p_iit_ne_id  IN     nm_inv_items.iit_ne_id%TYPE
                                     ,p_nte_job_id IN     nm_nw_temp_extents.nte_job_id%TYPE
                                     ) IS
--
   l_nte_inv nm_nw_temp_extents.nte_job_id%TYPE;
--
BEGIN
--
   nm3extent.create_temp_ne     (pi_source_id        => p_iit_ne_id
                                ,pi_source           => nm3extent.c_route
                                ,pi_begin_mp         => NULL
                                ,pi_end_mp           => NULL
                                ,po_job_id           => l_nte_inv
                                );
   nm3extent.combine_temp_nes   (pi_job_id_1         => p_nte_job_id
                                ,pi_job_id_2         => l_nte_inv
                                ,pi_check_overlaps   => FALSE
                                );
   nm3extent.defrag_temp_extent (pi_nte_id           => p_nte_job_id
                                ,pi_force_resequence => FALSE
                                );
--
END append_nte_to_existing_loc;
--
-----------------------------------------------------------------------------
--
PROCEDURE homo_update_internal (p_iit_ne_id      IN     nm_inv_items.iit_ne_id%TYPE
                               ,p_nte_job_id     IN     nm_nw_temp_extents.nte_job_id%TYPE
                               ,p_effective_date IN     date
                               ) IS
--
   l_warning_code varchar2(4000);
   l_warning_msg  varchar2(4000);
--
BEGIN
--
   nm3homo.homo_update (p_temp_ne_id_in  => p_nte_job_id
                       ,p_iit_ne_id      => p_iit_ne_id
                       ,p_effective_date => p_effective_date
                       ,p_warning_code   => l_warning_code
                       ,p_warning_msg    => l_warning_msg
                       );
--
END homo_update_internal;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_item (p_iit_ne_id                  IN     nm_inv_items.iit_ne_id%TYPE
                        ,p_effective_date             IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                        ) IS
--
   c_init_eff_date CONSTANT date := nm3user.get_effective_date;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'end_date_item');
--
   nm3user.set_effective_date (p_effective_date);
--
   nm3lock.lock_inv_item_and_members (pi_iit_ne_id      => p_iit_ne_id
                                     ,p_lock_for_update => TRUE
                                     );
--
   --Log 696122:Linesh:20-Feb-2009:Start
   --End date grouping record before end dating the asset.
   UPDATE nm_inv_item_groupings
   SET    iig_end_date = p_effective_date
   WHERE  iig_item_id  = p_iit_ne_id;
   --Log 696122:Linesh:20-Feb-2009:End

  
   UPDATE nm_inv_items
   SET   iit_end_date = p_effective_date
   WHERE  iit_ne_id    = p_iit_ne_id;
--
   nm3user.set_effective_date (c_init_eff_date);
--
   nm_debug.proc_end(g_package_name,'end_date_item');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_init_eff_date);
      RAISE;
--
END end_date_item;
--
-----------------------------------------------------------------------------
--
PROCEDURE end_date_item_location (p_iit_ne_id                  IN     nm_inv_items.iit_ne_id%TYPE
                                 ,p_effective_date             IN     nm_inv_items.iit_start_date%TYPE DEFAULT nm3user.get_effective_date
                                 ) IS
--
   future_dated exception;
   pragma exception_init( future_dated, -20000 );    
--

   c_init_eff_date CONSTANT date := nm3user.get_effective_date;
--
BEGIN
--
   nm_debug.proc_start(g_package_name,'end_date_item_location');
--
   begin
     check_item_has_no_future_locs(p_iit_ne_id, p_effective_date );
   exception
     when future_dated then
        hig.raise_ner (pi_appl => nm3type.c_net
                      ,pi_id   => 178
                      );
   end;
   
--
   nm3user.set_effective_date (p_effective_date);
--
   nm3lock.lock_inv_item_and_members (pi_iit_ne_id      => p_iit_ne_id
                                     ,p_lock_for_update => TRUE
                                     );
--
   UPDATE nm_members
    SET   nm_end_date = p_effective_date
   WHERE  nm_ne_id_in = p_iit_ne_id;
--
   nm3user.set_effective_date (c_init_eff_date);
--
   nm_debug.proc_end(g_package_name,'end_date_item_location');
--
EXCEPTION
--
   WHEN others
    THEN
      nm3user.set_effective_date (c_init_eff_date);
      RAISE;
--
END end_date_item_location;
--
-----------------------------------------------------------------------------
--
PROCEDURE copy_item(pi_item_to_copy   IN nm_inv_items.iit_ne_id%TYPE
                   ,pi_new_pk         IN nm_inv_items.iit_primary_key%TYPE
                   ,pi_effective_date IN date DEFAULT nm3user.get_effective_date
                   ,pi_copy_location  IN boolean DEFAULT TRUE
                   ,pi_cascade_xsp    IN boolean DEFAULT TRUE
                   ,pi_cascade_excl   IN boolean DEFAULT TRUE
                   ,pi_cascade_au     IN boolean DEFAULT TRUE
                   ) IS

  l_new_iit_rec nm_inv_items%ROWTYPE;
  
  l_nte_job_id nm_nw_temp_extents.nte_job_id%TYPE;

BEGIN
  nm_debug.proc_start(p_package_name   => g_package_name
                     ,p_procedure_name => 'copy_item');

  l_new_iit_rec := nm3get.get_iit(pi_iit_ne_id => pi_item_to_copy);
  
  l_new_iit_rec.iit_ne_id       := nm3net.get_next_ne_id;
  l_new_iit_rec.iit_primary_key := pi_new_pk;
  
  IF pi_copy_location
  THEN
    nm3extent.create_temp_ne(pi_source_id => pi_item_to_copy
                            ,pi_source    => nm3extent.c_route
                            ,po_job_id    => l_nte_job_id);
  END IF;
  
  nm3inv_copy.copy_item(pi_old_iit_ne_id  => pi_item_to_copy
                       ,pi_new_rec_iit    => l_new_iit_rec
                       ,pi_nte_job_id     => l_nte_job_id
                       ,pi_effective_date => pi_effective_date
                       ,pi_cascade_xsp    => pi_cascade_xsp
                       ,pi_cascade_excl   => pi_cascade_excl
                       ,pi_cascade_au     => pi_cascade_au);

  nm_debug.proc_end(p_package_name   => g_package_name
                   ,p_procedure_name => 'copy_item');

END copy_item;
--
-----------------------------------------------------------------------------
--
END nm3api_inv;
/
