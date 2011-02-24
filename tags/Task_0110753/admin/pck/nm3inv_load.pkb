CREATE OR REPLACE PACKAGE BODY Nm3inv_Load AS
--
-----------------------------------------------------------------------------
--
--   SCCS Identifiers :-
--
--       pvcsid           : $Header:   //vm_latest/archives/nm3/admin/pck/nm3inv_load.pkb-arc   2.6   Feb 24 2011 16:09:40   Ade.Edwards  $
--       Module Name      : $Workfile:   nm3inv_load.pkb  $
--       Date into PVCS   : $Date:   Feb 24 2011 16:09:40  $
--       Date fetched Out : $Modtime:   Feb 24 2011 16:08:46  $
--       PVCS Version     : $Revision:   2.6  $
--
--   Author : Jonathan Mills
--
--   NM3 Inventory Load package body
--
-----------------------------------------------------------------------------
--  Copyright (c) exor corporation ltd, 2002
-----------------------------------------------------------------------------
--
--all global package variables here
--
   g_body_sccsid     CONSTANT  VARCHAR2(2000) := '"$Revision:   2.6  $"';
--  g_body_sccsid is the SCCS ID for the package body
--
   g_package_name    CONSTANT  VARCHAR2(30)   := 'nm3inv_load';
   
   --c_hist_loc_enabled_opt CONSTANT hig_option_list.hol_id%TYPE := 'HISTINVLOC';
   --c_hist_loc_enabled     constant boolean := NVL(hig.get_sysopt(p_option_id => c_hist_loc_enabled_opt), 'N') = 'Y';
--
-----------------------------------------------------------------------------
--
PROCEDURE get_datum_lref (pi_route_ne_id               IN     nm_elements.ne_id%TYPE
                         ,pi_ne_group                  IN     nm_elements.ne_unique%TYPE
                         ,pi_slk                       IN     NUMBER
                         ,pi_sub_class                 IN     VARCHAR2
                         ,pi_is_begin                  IN     BOOLEAN DEFAULT FALSE
                         ,pi_use_true                  IN     BOOLEAN DEFAULT FALSE
                         ,po_datum_ne_id                  OUT nm_elements.ne_id%TYPE
                         ,po_datum_offset                 OUT NUMBER
                         ,pi_random_pick_on_ambig_fail IN     BOOLEAN DEFAULT FALSE
                         );
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ambiguous_lref (pi_route_ne_id               IN     nm_elements.ne_id%TYPE
                             ,pi_ne_group                  IN     nm_elements.ne_unique%TYPE
                             ,pi_slk                       IN     NUMBER
                             ,pi_sub_class                 IN     VARCHAR2
                             ,pi_is_begin                  IN     BOOLEAN DEFAULT FALSE
                             ,pi_use_true                  IN     BOOLEAN DEFAULT FALSE
                             ,po_datum_ne_id                  OUT nm_elements.ne_id%TYPE
                             ,po_datum_offset                 OUT NUMBER
                             ,pi_random_pick_on_ambig_fail IN     BOOLEAN DEFAULT FALSE
                             );
--
-----------------------------------------------------------------------------
--
PROCEDURE load_or_val_ele_mp_ambig (p_rec           v_load_inv_mem_ele_mp_ambig%ROWTYPE
                                   ,p_validate_only BOOLEAN
                                   ,p_use_true      BOOLEAN DEFAULT FALSE
                                   );
--
-----------------------------------------------------------------------------
--
PROCEDURE load_or_val_ele_mp_excl (p_rec           v_load_inv_mem_ele_mp_excl%ROWTYPE
                                  ,p_validate_only BOOLEAN
                                  ,p_use_true      BOOLEAN DEFAULT FALSE
                                  );
--
-----------------------------------------------------------------------------
--
--PROCEDURE load_or_val_on_element (p_rec           v_load_inv_mem_on_element%ROWTYPE
--                               ,p_validate_only BOOLEAN
 --                              );
--
-----------------------------------------------------------------------------
--
FUNCTION get_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_sccsid;
END get_version;
--
-----------------------------------------------------------------------------
--
FUNCTION get_body_version RETURN VARCHAR2 IS
BEGIN
   RETURN g_body_sccsid;
END get_body_version;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_ele_mp_ambig (p_rec v_load_inv_mem_ele_mp_ambig%ROWTYPE) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'load_ele_mp_ambig');
--
   load_or_val_ele_mp_ambig (p_rec           => p_rec
                            ,p_validate_only => FALSE
                            ,p_use_true      => FALSE
                            );
--
   Nm_Debug.proc_end(g_package_name,'load_ele_mp_ambig');
--
END load_ele_mp_ambig;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_ele_mp_ambig (p_rec v_load_inv_mem_ele_mp_ambig%ROWTYPE) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'validate_ele_mp_ambig');
--
   load_or_val_ele_mp_ambig (p_rec           => p_rec
                            ,p_validate_only => TRUE
                            ,p_use_true      => FALSE
                            );
--
   Nm_Debug.proc_end(g_package_name,'validate_ele_mp_ambig');
--
END validate_ele_mp_ambig;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_ele_mp_true_ambig (p_rec v_load_inv_mem_ele_mp_true_amb%ROWTYPE) IS
   l_rec v_load_inv_mem_ele_mp_ambig%ROWTYPE;
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'load_ele_mp_true_ambig');
--
   l_rec.ne_unique               := p_rec.ne_unique;
   l_rec.ne_nt_type              := p_rec.ne_nt_type;
   l_rec.begin_mp                := p_rec.begin_mp;
   l_rec.end_mp                  := p_rec.end_mp;
   l_rec.subclass_when_ambiguous := p_rec.subclass_when_ambiguous;
   l_rec.iit_ne_id               := p_rec.iit_ne_id;
   l_rec.iit_inv_type            := p_rec.iit_inv_type;
   l_rec.nm_start_date           := p_rec.nm_start_date;
--
   load_or_val_ele_mp_ambig (p_rec           => l_rec
                            ,p_validate_only => FALSE
                            ,p_use_true      => TRUE
                            );
--
   Nm_Debug.proc_end(g_package_name,'load_ele_mp_true_ambig');
--
END load_ele_mp_true_ambig;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_ele_mp_true_ambig (p_rec v_load_inv_mem_ele_mp_true_amb%ROWTYPE) IS
   l_rec v_load_inv_mem_ele_mp_ambig%ROWTYPE;
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'validate_ele_mp_true_ambig');
--
   l_rec.ne_unique               := p_rec.ne_unique;
   l_rec.ne_nt_type              := p_rec.ne_nt_type;
   l_rec.begin_mp                := p_rec.begin_mp;
   l_rec.end_mp                  := p_rec.end_mp;
   l_rec.subclass_when_ambiguous := p_rec.subclass_when_ambiguous;
   l_rec.iit_ne_id               := p_rec.iit_ne_id;
   l_rec.iit_inv_type            := p_rec.iit_inv_type;
   l_rec.nm_start_date           := p_rec.nm_start_date;
--
   load_or_val_ele_mp_ambig (p_rec           => l_rec
                            ,p_validate_only => TRUE
                            ,p_use_true      => TRUE
                            );
--
   Nm_Debug.proc_end(g_package_name,'validate_ele_mp_true_ambig');
--
END validate_ele_mp_true_ambig;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_or_val_ele_mp_ambig (p_rec           v_load_inv_mem_ele_mp_ambig%ROWTYPE
                                   ,p_validate_only BOOLEAN
                                   ,p_use_true      BOOLEAN DEFAULT FALSE
                                   ) IS
--
   c_init_effective_date CONSTANT date := nm3user.get_effective_date;

   l_nte_job_id   nm_nw_temp_extents.nte_job_id%TYPE;
--
   l_route_ne_id  nm_elements.ne_id%TYPE;
--
   l_start_ne_id  nm_elements.ne_id%TYPE;
   l_start_offset NUMBER;
--
   l_end_ne_id    nm_elements.ne_id%TYPE;
   l_end_offset   NUMBER;
--
   l_end_mp       NUMBER := NVL(p_rec.end_mp,p_rec.begin_mp);
--
   nothing_to_do  EXCEPTION;
--
BEGIN
--
--nm_Debug.delete_debug(TRUE);
--nm_debug.debug_on;
   SAVEPOINT top_of_load;
--
   IF  p_rec.ne_unique IS NULL
    OR p_rec.begin_mp  IS NULL
    THEN
      RAISE nothing_to_do;
   END IF;
   
   nm3homo.historic_locate_init(pi_effective_date => p_rec.nm_start_date);
--
   l_route_ne_id := nm3net.get_ne_id (p_rec.ne_unique,p_rec.ne_nt_type);
--
   get_datum_lref (pi_route_ne_id  => l_route_ne_id
                  ,pi_ne_group     => p_rec.ne_unique
                  ,pi_slk          => p_rec.begin_mp
                  ,pi_sub_class    => p_rec.subclass_when_ambiguous
                  ,pi_is_begin     => TRUE
                  ,pi_use_true     => p_use_true
                  ,po_datum_ne_id  => l_start_ne_id
                  ,po_datum_offset => l_start_offset
                  );
 --
   IF p_rec.begin_mp = l_end_mp
    THEN
      l_end_ne_id  := l_start_ne_id;
      l_end_offset := l_start_offset;
   ELSE
      get_datum_lref (pi_route_ne_id  => l_route_ne_id
                     ,pi_ne_group     => p_rec.ne_unique
                     ,pi_slk          => l_end_mp
                     ,pi_sub_class    => p_rec.subclass_when_ambiguous
                     ,pi_is_begin     => FALSE
                     ,pi_use_true     => p_use_true
                     ,po_datum_ne_id  => l_end_ne_id
                     ,po_datum_offset => l_end_offset
                     );
   END IF;
--
   IF p_validate_only
    AND NOT g_create_temp_ne_on_validate
    THEN
      g_last_nte_job_id := -1;
   ELSE
      nm3wrap.create_temp_ne_from_route (pi_route                   => l_route_ne_id
                                        ,pi_start_ne_id             => l_start_ne_id
                                        ,pi_start_offset            => l_start_offset
                                        ,pi_end_ne_id               => l_end_ne_id
                                        ,pi_end_offset              => l_end_offset
                                        ,pi_sub_class               => p_rec.subclass_when_ambiguous
                                        ,pi_restrict_excl_sub_class => 'N'
                                        ,pi_homo_check              => TRUE
                                        ,po_job_id                  => l_nte_job_id
                                        );
      g_last_nte_job_id := l_nte_job_id;
   END IF;
--
   nm3homo.historic_locate_validation(pi_nte_job_id   => l_nte_job_id
                                     ,pi_user_ne_id   => l_route_ne_id
                                     ,pi_user_ne_type => nm3net.get_ne(pi_ne_id => l_route_ne_id).ne_type);

   IF NOT p_validate_only
    THEN
      nm3homo.homo_update (p_temp_ne_id_in  => l_nte_job_id
                          ,p_iit_ne_id      => p_rec.iit_ne_id
                          ,p_effective_date => p_rec.nm_start_date
                          );
   END IF;
   
   nm3homo.historic_locate_post(pi_init_effective_date => c_init_effective_date);
--nm_debug.debug_off;
--
EXCEPTION
--
   WHEN nothing_to_do
    THEN
      Null;
   WHEN others
    THEN
      ROLLBACK TO top_of_load;
      nm3homo.historic_locate_post(pi_init_effective_date => c_init_effective_date);
      RAISE;
--
END load_or_val_ele_mp_ambig;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_ele_mp_excl (p_rec v_load_inv_mem_ele_mp_excl%ROWTYPE) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'load_ele_mp_excl');
--
   load_or_val_ele_mp_excl (p_rec           => p_rec
                           ,p_validate_only => FALSE
                           ,p_use_true      => FALSE
                           );
--
   Nm_Debug.proc_end(g_package_name,'load_ele_mp_excl');
--
END load_ele_mp_excl;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_ele_mp_excl (p_rec v_load_inv_mem_ele_mp_excl%ROWTYPE) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'validate_ele_mp_excl');
--
   load_or_val_ele_mp_excl (p_rec           => p_rec
                           ,p_validate_only => TRUE
                           ,p_use_true      => FALSE
                           );
--
   Nm_Debug.proc_end(g_package_name,'validate_ele_mp_excl');
--
END validate_ele_mp_excl;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_ele_mp_true_excl (p_rec v_load_inv_mem_ele_mp_true_exc%ROWTYPE) IS
   l_rec v_load_inv_mem_ele_mp_excl%ROWTYPE;
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'load_ele_mp_true_excl');
--
   l_rec.ne_unique               := p_rec.ne_unique;
   l_rec.ne_nt_type              := p_rec.ne_nt_type;
   l_rec.begin_mp                := p_rec.begin_mp;
   l_rec.end_mp                  := p_rec.end_mp;
   l_rec.exclusive_subclass      := p_rec.exclusive_subclass;
   l_rec.iit_ne_id               := p_rec.iit_ne_id;
   l_rec.iit_inv_type            := p_rec.iit_inv_type;
   l_rec.nm_start_date           := p_rec.nm_start_date;
--
   load_or_val_ele_mp_excl (p_rec           => l_rec
                           ,p_validate_only => FALSE
                           ,p_use_true      => TRUE
                           );
--
   Nm_Debug.proc_end(g_package_name,'load_ele_mp_true_excl');
--
END load_ele_mp_true_excl;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_ele_mp_true_excl (p_rec v_load_inv_mem_ele_mp_true_exc%ROWTYPE) IS
   l_rec v_load_inv_mem_ele_mp_excl%ROWTYPE;
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'validate_ele_mp_true_excl');
--
   l_rec.ne_unique               := p_rec.ne_unique;
   l_rec.ne_nt_type              := p_rec.ne_nt_type;
   l_rec.begin_mp                := p_rec.begin_mp;
   l_rec.end_mp                  := p_rec.end_mp;
   l_rec.exclusive_subclass      := p_rec.exclusive_subclass;
   l_rec.iit_ne_id               := p_rec.iit_ne_id;
   l_rec.iit_inv_type            := p_rec.iit_inv_type;
   l_rec.nm_start_date           := p_rec.nm_start_date;
--
   load_or_val_ele_mp_excl (p_rec           => l_rec
                           ,p_validate_only => TRUE
                           ,p_use_true      => TRUE
                           );
--
   Nm_Debug.proc_end(g_package_name,'validate_ele_mp_true_excl');
--
END validate_ele_mp_true_excl;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_or_val_ele_mp_excl (p_rec           v_load_inv_mem_ele_mp_excl%ROWTYPE
                                  ,p_validate_only BOOLEAN
                                  ,p_use_true      BOOLEAN DEFAULT FALSE
                                  ) IS
--
   c_init_effective_date CONSTANT date := nm3user.get_effective_date;
   
   l_nte_job_id   nm_nw_temp_extents.nte_job_id%TYPE;
--
   l_route_ne_id  nm_elements.ne_id%TYPE;
--
   l_start_ne_id  nm_elements.ne_id%TYPE;
   l_start_offset NUMBER;
--
   l_end_ne_id    nm_elements.ne_id%TYPE;
   l_end_offset   NUMBER;
--
   l_end_mp       NUMBER := NVL(p_rec.end_mp,p_rec.begin_mp);
--
   nothing_to_do  EXCEPTION;
--
BEGIN
--
   SAVEPOINT top_of_load;
--
   IF  p_rec.ne_unique IS NULL
    OR p_rec.begin_mp  IS NULL
    THEN
      RAISE nothing_to_do;
   END IF;
--
   nm3homo.historic_locate_init(pi_effective_date => p_rec.nm_start_date);
   
   l_route_ne_id := nm3net.get_ne_id (p_rec.ne_unique,p_rec.ne_nt_type);
--
   get_datum_lref (pi_route_ne_id  => l_route_ne_id
                  ,pi_ne_group     => p_rec.ne_unique
                  ,pi_slk          => p_rec.begin_mp
                  ,pi_sub_class    => p_rec.exclusive_subclass
                  ,pi_is_begin     => TRUE
                  ,pi_use_true     => p_use_true
                  ,po_datum_ne_id  => l_start_ne_id
                  ,po_datum_offset => l_start_offset
                  );
 --
   IF p_rec.begin_mp = l_end_mp
    THEN
      l_end_ne_id  := l_start_ne_id;
      l_end_offset := l_start_offset;
   ELSE
      get_datum_lref (pi_route_ne_id  => l_route_ne_id
                     ,pi_ne_group     => p_rec.ne_unique
                     ,pi_slk          => l_end_mp
                     ,pi_sub_class    => p_rec.exclusive_subclass
                     ,pi_is_begin     => FALSE
                     ,pi_use_true     => FALSE
                     ,po_datum_ne_id  => l_end_ne_id
                     ,po_datum_offset => l_end_offset
                     );
   END IF;
--
   IF p_validate_only
    AND NOT g_create_temp_ne_on_validate
    THEN
      g_last_nte_job_id := -1;
   ELSE
      nm3wrap.create_temp_ne_from_route (pi_route                   => l_route_ne_id
                                        ,pi_start_ne_id             => l_start_ne_id
                                        ,pi_start_offset            => l_start_offset
                                        ,pi_end_ne_id               => l_end_ne_id
                                        ,pi_end_offset              => l_end_offset
                                        ,pi_sub_class               => p_rec.exclusive_subclass
                                        ,pi_restrict_excl_sub_class => 'Y'
                                        ,pi_homo_check              => TRUE
                                        ,po_job_id                  => l_nte_job_id
                                        );
      g_last_nte_job_id := l_nte_job_id;
   END IF;
--
   nm3homo.historic_locate_validation(pi_nte_job_id   => l_nte_job_id
                                     ,pi_user_ne_id   => l_route_ne_id
                                     ,pi_user_ne_type => nm3net.get_ne(pi_ne_id => l_route_ne_id).ne_type);

   IF NOT p_validate_only
    THEN
      nm3homo.homo_update (p_temp_ne_id_in  => l_nte_job_id
                          ,p_iit_ne_id      => p_rec.iit_ne_id
                          ,p_effective_date => p_rec.nm_start_date
                          );
   END IF;
   
   nm3homo.historic_locate_post(pi_init_effective_date => c_init_effective_date);
--
EXCEPTION
--
   WHEN nothing_to_do
    THEN
      Null;
   WHEN others
    THEN
      ROLLBACK TO top_of_load;
      nm3homo.historic_locate_post(pi_init_effective_date => c_init_effective_date);
      RAISE;
--
END load_or_val_ele_mp_excl;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_on_element (p_rec v_load_inv_mem_on_element%ROWTYPE) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'load_on_element');
--
   load_or_val_on_element (p_rec           => p_rec
                          ,p_validate_only => FALSE
                          );
--
   Nm_Debug.proc_end(g_package_name,'load_on_element');
--
END load_on_element;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_on_element (p_rec v_load_inv_mem_on_element%ROWTYPE) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'validate_on_element');
--
   load_or_val_on_element (p_rec           => p_rec
                          ,p_validate_only => TRUE
                          );
--
   Nm_Debug.proc_end(g_package_name,'validate_on_element');
--
END validate_on_element;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_or_val_on_element (p_rec           v_load_inv_mem_on_element%ROWTYPE
                                 ,p_validate_only BOOLEAN
                                 ) IS
--
   c_init_effective_date constant date := nm3user.get_effective_date;
   
   l_rec_ne       nm_elements%ROWTYPE;
--
   nothing_to_do  EXCEPTION;
--
   l_begin_mp     NUMBER;
   l_end_mp       NUMBER;
   l_nte_job_id   nm_nw_temp_extents.nte_job_id%TYPE;
--
   c_end_mp CONSTANT NUMBER := NVL(p_rec.end_mp,p_rec.begin_mp);
--
BEGIN
--
   SAVEPOINT top_of_load;
--
   IF  p_rec.ne_unique IS NULL
    THEN
      RAISE nothing_to_do;
   END IF;
--
   nm3homo.historic_locate_init(pi_effective_date => p_rec.nm_start_date);

   l_rec_ne := nm3get.get_ne (pi_ne_id  => nm3net.get_ne_id (p_rec.ne_unique,p_rec.ne_nt_type));
--
   IF   NVL(p_rec.begin_mp,0)            = 0
    AND NVL(c_end_mp,l_rec_ne.ne_length) = l_rec_ne.ne_length
    THEN
      l_begin_mp := Null;
      l_end_mp   := Null;
   ELSE
      l_begin_mp := p_rec.begin_mp;
      l_end_mp   := c_end_mp;
   END IF;
--
   nm3extent.create_temp_ne (pi_source_id => l_rec_ne.ne_id
                            ,pi_source    => nm3extent.c_route
                            ,pi_begin_mp  => l_begin_mp
                            ,pi_end_mp    => l_end_mp
                            ,po_job_id    => l_nte_job_id
                            );
--
   nm3extent.remove_db_from_temp_ne (l_nte_job_id);
--
   nm3homo.check_temp_ne_for_pnt_or_cont (pi_nte_job_id  => l_nte_job_id
                                         ,pi_pnt_or_cont => nm3get.get_nit (pi_nit_inv_type=>p_rec.iit_inv_type).nit_pnt_or_cont
                                         );

   nm3homo.historic_locate_validation(pi_nte_job_id   => l_nte_job_id
                                     ,pi_user_ne_id   => l_rec_ne.ne_id
                                     ,pi_user_ne_type => l_rec_ne.ne_type);
   
   IF p_validate_only
    THEN
      IF NOT g_create_temp_ne_on_validate
       THEN
         ROLLBACK TO top_of_load;
         g_last_nte_job_id := -1;
      END IF;
   ELSE
      nm3homo.homo_update (p_temp_ne_id_in  => l_nte_job_id
                          ,p_iit_ne_id      => p_rec.iit_ne_id
                          ,p_effective_date => p_rec.nm_start_date
                          );
   END IF;
--
   g_last_nte_job_id := l_nte_job_id;
   
   nm3homo.historic_locate_post(pi_init_effective_date => c_init_effective_date);
--
EXCEPTION
--
   WHEN nothing_to_do
    THEN
      Null;

   WHEN others
    THEN
      ROLLBACK TO top_of_load;
      nm3homo.historic_locate_post(pi_init_effective_date => c_init_effective_date);
      RAISE;
--
END load_or_val_on_element;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_datum_lref (pi_route_ne_id               IN     nm_elements.ne_id%TYPE
                         ,pi_ne_group                  IN     nm_elements.ne_unique%TYPE
                         ,pi_slk                       IN     NUMBER
                         ,pi_sub_class                 IN     VARCHAR2
                         ,pi_is_begin                  IN     BOOLEAN DEFAULT FALSE
                         ,pi_use_true                  IN     BOOLEAN DEFAULT FALSE
                         ,po_datum_ne_id                  OUT nm_elements.ne_id%TYPE
                         ,po_datum_offset                 OUT NUMBER
                         ,pi_random_pick_on_ambig_fail IN     BOOLEAN DEFAULT FALSE
                         ) IS
   c_sub_class CONSTANT   nm_elements.ne_sub_class%TYPE := Nm3flx.i_t_e (pi_sub_class = 'S'
                                                                        ,NULL
                                                                        ,pi_sub_class
                                                                        );
BEGIN
--
--nm_debug.debug('In get_datum_lref');
--nm_debug.debug('pi_route_ne_id  : '||pi_route_ne_id);
--nm_debug.debug('pi_ne_group     : '||pi_ne_group);
--nm_debug.debug('pi_slk          : '||pi_slk);
--nm_debug.debug('pi_sub_class    : '||pi_sub_class);
--nm_debug.debug('pi_is_begin     : '||nm3flx.boolean_to_char(pi_is_begin));
--nm_debug.debug('pi_use_true     : '||nm3flx.boolean_to_char(pi_use_true));
   DECLARE
      l_ambig EXCEPTION;
      PRAGMA EXCEPTION_INIT (l_ambig,-20002);
      l_lref  nm_lref;
   BEGIN
      IF pi_use_true
       THEN
         l_lref       := Nm3lrs.get_datum_true_offset (pi_ne_id     => pi_route_ne_id
                                                      ,pi_true      => pi_slk
                                                      ,pi_sub_class => c_sub_class
                                                      );
      ELSE
         l_lref       := Nm3lrs.get_datum_offset(p_parent_lr => nm_lref(pi_route_ne_id,pi_slk));
      END IF;
      po_datum_ne_id  := l_lref.lr_ne_id;
      po_datum_offset := l_lref.lr_offset;
   EXCEPTION
      WHEN l_ambig
       THEN
         get_ambiguous_lref (pi_route_ne_id               => pi_route_ne_id
                            ,pi_ne_group                  => pi_ne_group
                            ,pi_slk                       => pi_slk
                            ,pi_sub_class                 => pi_sub_class
                            ,pi_is_begin                  => pi_is_begin
                            ,pi_use_true                  => pi_use_true
                            ,pi_random_pick_on_ambig_fail => pi_random_pick_on_ambig_fail
                            ,po_datum_ne_id               => po_datum_ne_id
                            ,po_datum_offset              => po_datum_offset
                            );
   END;
--        nm_debug.debug('Returning : '||nm3net.get_ne_unique(po_datum_ne_id)||':'||po_datum_offset);
--
END get_datum_lref;
--
-----------------------------------------------------------------------------
--
PROCEDURE get_ambiguous_lref (pi_route_ne_id               IN     nm_elements.ne_id%TYPE
                             ,pi_ne_group                  IN     nm_elements.ne_unique%TYPE
                             ,pi_slk                       IN     NUMBER
                             ,pi_sub_class                 IN     VARCHAR2
                             ,pi_is_begin                  IN     BOOLEAN DEFAULT FALSE
                             ,pi_use_true                  IN     BOOLEAN DEFAULT FALSE
                             ,po_datum_ne_id                  OUT nm_elements.ne_id%TYPE
                             ,po_datum_offset                 OUT NUMBER
                             ,pi_random_pick_on_ambig_fail IN     BOOLEAN DEFAULT FALSE
                             ) IS
--
   l_end_of_section_found BOOLEAN;
   c_sub_class CONSTANT   nm_elements.ne_sub_class%TYPE := Nm3flx.i_t_e (pi_sub_class = 'S'
                                                                        ,NULL
                                                                        ,pi_sub_class
                                                                        );
--
   l_lref_count           PLS_INTEGER;
   l_child_units          nm_units.un_unit_id%TYPE;
   l_parent_units         nm_units.un_unit_id%TYPE;
   l_lref_tab             Nm3lrs.lref_table;
--
BEGIN
--
   Nm3net.get_group_units (pi_ne_id       => pi_route_ne_id
                          ,po_group_units => l_parent_units
                          ,po_child_units => l_child_units
                          );
--
   IF pi_use_true
    THEN
     Nm3lrs.get_ambiguous_lrefs_true (p_parent_id    => pi_route_ne_id
                                     ,p_parent_units => l_parent_units
                                     ,p_datum_units  => l_child_units
                                     ,p_offset       => pi_slk
                                     ,p_lrefs        => l_lref_tab
                                     ,p_sub_class    => c_sub_class
                                     );
   ELSE
     Nm3lrs.get_ambiguous_lrefs (p_parent_id    => pi_route_ne_id
                                ,p_parent_units => l_parent_units
                                ,p_datum_units  => l_child_units
                                ,p_offset       => pi_slk
                                ,p_lrefs        => l_lref_tab
                                ,p_sub_class    => c_sub_class
                                );
   END IF;
--
   l_lref_count := l_lref_tab.COUNT;
 --
   IF    l_lref_count = 0
    THEN
      Hig.raise_ner (pi_appl               => Nm3type.c_net
                    ,pi_id                 => 85
                    ,pi_supplementary_info => pi_ne_group||':'||pi_slk
                    );
   ELSIF l_lref_count > 1
    THEN
      l_end_of_section_found := FALSE;
      FOR i IN 1..l_lref_count
       LOOP
         po_datum_ne_id  := l_lref_tab(i).r_ne_id;
         po_datum_offset := l_lref_tab(i).r_offset;
 --        nm_debug.debug(i||'. '||nm3net.get_ne_unique(po_datum_ne_id)||':'||po_datum_offset);
         IF  (NOT pi_is_begin AND po_datum_offset = Nm3net.get_datum_element_length (po_datum_ne_id))
          OR (    pi_is_begin AND po_datum_offset = 0)
          THEN
 --           nm_Debug.debug('match');
            l_end_of_section_found := TRUE;
            EXIT;
         END IF;
      END LOOP;
      IF NOT l_end_of_section_found
       THEN
         IF pi_random_pick_on_ambig_fail
          THEN
            po_datum_ne_id  := l_lref_tab(1).r_ne_id;
            po_datum_offset := l_lref_tab(1).r_offset;
         ELSE
            Hig.raise_ner (pi_appl               => Nm3type.c_net
                          ,pi_id                 => 312
                          ,pi_supplementary_info => pi_ne_group||':'||pi_slk
                          );
         END IF;
      END IF;
   ELSE
      po_datum_ne_id  := l_lref_tab(1).r_ne_id;
      po_datum_offset := l_lref_tab(1).r_offset;
   END IF;
--
END get_ambiguous_lref;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_or_validate_point_on_ele (p_rec           v_load_point_inv_mem_on_ele%ROWTYPE
                                        ,p_validate_only BOOLEAN
                                        ) IS
--
   c_init_effective_date constant date := nm3user.get_effective_date; 
   
   l_rec_ne   nm_elements%ROWTYPE;
   l_rec_nte  nm_nw_temp_extents%ROWTYPE;
--
BEGIN
--
   nm3homo.historic_locate_init(pi_effective_date => p_rec.nm_start_date);

   l_rec_ne := nm3get.get_ne (pi_ne_unique  => p_rec.ne_unique
                             ,pi_ne_nt_type => p_rec.ne_nt_type
                             );
--
   get_datum_lref (pi_route_ne_id               => l_rec_ne.ne_id
                  ,pi_ne_group                  => l_rec_ne.ne_unique
                  ,pi_slk                       => p_rec.mp
                  ,pi_sub_class                 => p_rec.ambiguous_sub_class
                  ,pi_is_begin                  => (p_rec.ambig_choose_start_or_end = 'S')
                  ,pi_use_true                  => (p_rec.true_or_slk = 'TRUE')
                  ,pi_random_pick_on_ambig_fail => (p_rec.guess_if_still_ambiguous = 'Y')
                  ,po_datum_ne_id               => l_rec_nte.nte_ne_id_of
                  ,po_datum_offset              => l_rec_nte.nte_begin_mp
                  );
--
   IF NOT p_validate_only
    THEN
      l_rec_nte.nte_job_id      := nm3net.get_next_nte_id;
      l_rec_nte.nte_end_mp      := l_rec_nte.nte_begin_mp;
      l_rec_nte.nte_cardinality := 1;
      l_rec_nte.nte_seq_no      := 1;
      l_rec_nte.nte_route_ne_id := l_rec_ne.ne_id;
      nm3extent.ins_nte   (l_rec_nte);
      
      nm3homo.historic_locate_validation(pi_nte_job_id   => l_rec_nte.nte_job_id
                                        ,pi_user_ne_id   => l_rec_ne.ne_id
                                        ,pi_user_ne_type => l_rec_ne.ne_type);
      
      nm3homo.homo_update (p_temp_ne_id_in  => l_rec_nte.nte_job_id
                          ,p_iit_ne_id      => p_rec.iit_ne_id
                          ,p_effective_date => p_rec.nm_start_date
                          );
   END IF;
   
   nm3homo.historic_locate_post(pi_init_effective_date => c_init_effective_date);
--
END load_or_validate_point_on_ele;
--
-----------------------------------------------------------------------------
--
PROCEDURE load_point_on_ele (p_rec v_load_point_inv_mem_on_ele%ROWTYPE) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'load_point_on_ele');
--
   load_or_validate_point_on_ele (p_rec           => p_rec
                                 ,p_validate_only => FALSE
                                 );
--
   Nm_Debug.proc_end(g_package_name,'load_point_on_ele');
--
END load_point_on_ele;
--
-----------------------------------------------------------------------------
--
PROCEDURE validate_point_on_ele (p_rec v_load_point_inv_mem_on_ele%ROWTYPE) IS
BEGIN
--
   Nm_Debug.proc_start(g_package_name,'validate_point_on_ele');
--
   load_or_validate_point_on_ele (p_rec           => p_rec
                                 ,p_validate_only => TRUE
                                 );
--
   Nm_Debug.proc_end(g_package_name,'validate_point_on_ele');
--
END validate_point_on_ele;
--
-----------------------------------------------------------------------------

PROCEDURE load_on_element_xy (p_rec v_load_inv_mem_on_element_xy%ROWTYPE) IS

l_row v_load_inv_mem_on_element%ROWTYPE := translate_xy_to_element( p_rec );

BEGIN
  load_on_element( l_row );
END;

--
-----------------------------------------------------------------------------
--
PROCEDURE validate_on_element_xy (p_rec v_load_inv_mem_on_element_xy%ROWTYPE) IS

l_row v_load_inv_mem_on_element%ROWTYPE := translate_xy_to_element( p_rec );

BEGIN
  validate_on_element( l_row );
END;

-----------------------------------------------------------------------------
--

FUNCTION translate_xy_to_element 
             ( p_row IN v_load_inv_mem_on_element_xy%ROWTYPE ) 
  RETURN v_load_inv_mem_on_element%ROWTYPE IS
--
  l_lref       nm_lref;
  l_route_ne   nm_elements.ne_id%TYPE;
  retval       v_load_inv_mem_on_element%ROWTYPE;
--
BEGIN
--
--check the row is consistent
  IF p_row.begin_x IS NULL 
  OR p_row.begin_y IS NULL 
  THEN

    RAISE_APPLICATION_ERROR(-20001,'Error - start xy is required');

  ELSE
  
    IF  p_row.end_x IS NOT NULL 
    AND p_row.end_y IS NOT NULL 
    THEN
    
--    we need both x and y for the ned position of linear data
      l_route_ne      := nm3net.get_ne_id( p_row.ne_unique, p_row.ne_nt_type );
      l_lref          := xnltw_get_nearest_on_route(l_route_ne, p_row.begin_x, p_row.begin_y );
      retval.begin_mp := nm3lrs.get_set_offset(l_route_ne, l_lref.lr_ne_id, l_lref.lr_offset);
--
      l_lref := xnltw_get_nearest_on_route(l_route_ne, p_row.end_x, p_row.end_y );
      retval.end_mp := nm3lrs.get_set_offset(l_route_ne, l_lref.lr_ne_id, l_lref.lr_offset);
      
--      IF retval.begin_mp > retval.end_mp
--      THEN
--        -- Swap the chainages if they are the wrong way round
--        DECLARE
--          l_new_start nm_members.nm_begin_mp%TYPE;
--          l_new_end   nm_members.nm_end_mp%TYPE;
--        BEGIN
--          l_new_start := retval.end_mp;
--          l_new_end   := retval.begin_mp;
--          retval.begin_mp := l_new_start;
--          retval.end_mp   := l_new_end;
--        END;
--      END IF;

--    ELSIF p_row.end_x IS NULL 
--       OR p_row.end_y IS NULL  
--    THEN

--      RAISE_APPLICATION_ERROR(-20002,'Error - end xy is required');

    ELSE
    
--    we have just begin xy - its a point.

      l_route_ne      := nm3net.get_ne_id( p_row.ne_unique, p_row.ne_nt_type );
      l_lref          := xnltw_get_nearest_on_route(l_route_ne, p_row.begin_x, p_row.begin_y );
      retval.begin_mp := nm3lrs.get_set_offset(l_route_ne, l_lref.lr_ne_id, l_lref.lr_offset);

    END IF;

  END IF;  
--
  retval.ne_unique       := p_row.ne_unique;
  retval.ne_nt_type      := p_row.ne_nt_type;
  retval.iit_ne_id       := p_row.iit_ne_id;
  retval.iit_inv_type    := p_row.iit_inv_type;
  retval.nm_start_date   := p_row.nm_start_date;
--
  --nm_debug.debug_on;
  nm_debug.debug('Ne ID= '||retval.ne_unique||' - begin = '||retval.begin_mp||' - end = '||retval.end_mp);
  RETURN retval;
--
EXCEPTION
  WHEN NO_DATA_FOUND
  THEN RAISE_APPLICATION_ERROR
    (-20101,'No network found in tolerance '||p_row.ne_unique);
END translate_xy_to_element;
--
-----------------------------------------------------------------------------
--
FUNCTION xnltw_get_nearest_on_route
   ( p_ne_id    IN NUMBER
   , p_x        IN NUMBER
   , p_y        IN NUMBER )
RETURN nm_lref 
IS
--
  l_theme_id  nm_themes_all.nth_theme_id%TYPE;
  l_tol       nm_themes_all.nth_tolerance%TYPE;
  l_unit      nm_themes_all.nth_tol_units%TYPE;
  l_geom      mdsys.sdo_geometry;
  l_ne        nm_elements%ROWTYPE;
  l_ne_id     nm_elements.ne_id%TYPE;
  l_dist      NUMBER;
  retval      nm_lref;

cursor get_theme (c_ne_gty_group_type nm_elements.ne_gty_group_type%type ) is
  SELECT nnth_nth_theme_id, nth_tolerance, nth_tol_units
    FROM nm_nw_themes
       , nm_linear_types
       , nm_nt_groupings
       , nm_themes_all
   WHERE nnth_nlt_id = nlt_id
     AND nnth_nth_theme_id = nth_theme_id
     AND nlt_nt_type = nng_nt_type
     AND nng_group_type = c_ne_gty_group_type
     AND nlt_g_i_d = 'D'
     order by decode(nth_base_table_theme, NULL, 'B', 'A');  
--
BEGIN
--
  l_ne := Nm3get.get_ne( p_ne_id );
--
  open get_theme( l_ne.ne_gty_group_type );
  fetch get_theme INTO l_theme_id, l_tol, l_unit;
  if get_theme%notfound then
    close get_theme;
    raise_application_error(-20001, 'No theme found' );
  end if;
  close get_theme;

--  
  --nm_debug.debug_on;
  nm_debug.debug(l_theme_id||' - ');
  l_ne_id := nm3sdo.get_nearest_to_xy_on_route( l_theme_id, p_ne_id, p_x, p_y );
--
  l_dist := nm3sdo.get_distance(l_theme_id, l_ne_id, p_x, p_y );
--
  IF l_dist > l_tol 
  THEN
    RAISE_APPLICATION_ERROR(-20001,'Cannot find element within tolerance');
  ELSE
  --
    l_geom := nm3sdo.get_projection( l_theme_id, l_ne_id, p_x, p_y);
  --
    RETURN nm_lref( l_ne_id
                  , nm3unit.get_formatted_value( l_geom.sdo_ordinates(3)
                                              ,  nm3net.get_nt_units_from_ne(l_ne_id)
                                              )
                  );
  --
  END IF;
--
END xnltw_get_nearest_on_route;

--
-----------------------------------------------------------------------------
--

PROCEDURE process_line_data 
        ( pi_asset_type         IN nm_inv_types.nit_inv_type%TYPE
        , pi_load_file_unique   IN nm_load_files.nlf_unique%TYPE
        , pi_batch_no           IN nm_load_batches.nlb_batch_no%TYPE
        , pi_join_column        IN VARCHAR2 DEFAULT 'LFK'
        , pi_locate_ref_column  IN VARCHAR2 DEFAULT 'LOCATEREF'
        , po_nlf_id            OUT nm_load_files.nlf_id%TYPE
        , po_nlb_batch_no      OUT nm_load_batches.nlb_batch_no%TYPE)
 IS
   l_rec_nlf            nm_load_files%ROWTYPE;
   l_rec_nlb            nm_load_batches%ROWTYPE;
   l_batch_no           pls_integer;
   l_holding_table      VARCHAR2(30) := 'NM_LD_'||pi_load_file_unique||'_TMP';
   l_new_holding_table  VARCHAR2(30) := 'NM_LD_'||pi_load_file_unique||'_'||g_line_data_suffix||'_TMP';
   l_sql_1              nm3type.max_varchar2;
   l_sql_2              nm3type.max_varchar2;
   l_rec_batch_retval   nm_load_batches%ROWTYPE;
--
-------------------------------------------------------------------------------
--
  FUNCTION get_tab_cols ( pi_table  IN VARCHAR2 ) RETURN nm3type.max_varchar2
  IS
    l_retval nm3type.max_varchar2;
  BEGIN
    FOR i IN 
      (SELECT column_name||', ' a
         FROM user_tab_columns
        WHERE table_name = pi_table
        ORDER BY column_id)
    LOOP
      l_retval := l_retval||i.a;
    END LOOP;
    RETURN l_retval;
  END get_tab_cols;
--
-------------------------------------------------------------------------------
--
  FUNCTION get_tab_select_cols ( pi_table  IN VARCHAR2 
                                ,pi_prefix IN VARCHAR2 ) RETURN nm3type.max_varchar2
  IS
    l_retval nm3type.max_varchar2;
  BEGIN
    FOR i IN 
      (SELECT pi_prefix||'.'||column_name||', ' a
         FROM user_tab_columns
        WHERE table_name = pi_table
          AND column_name != 'BATCH_NO'
        ORDER BY column_id)
    LOOP
      l_retval := l_retval||i.a;
    END LOOP;
    RETURN l_retval;
  END get_tab_select_cols;
--
  FUNCTION get_lat_long ( pi_file_id IN number
                        , pi_column  IN VARCHAR )
    RETURN VARCHAR2
  IS
    retval VARCHAR2(100);
  BEGIN
    select substr(nlcd_source_col,(instr(nlcd_source_col,'.')+1),length(nlcd_source_col))
    into   retval
    from   NM_LOAD_FILE_COL_DESTINATIONS
    where  nlcd_nlf_id = pi_file_id
    and    nlcd_dest_col = pi_column;
    RETURN retval;
  END get_lat_long;
--
-------------------------------------------------------------------------------
--
BEGIN
--
  l_rec_nlf := nm3get.get_nlf (pi_nlf_unique   => pi_load_file_unique||'_'||g_line_data_suffix);
  l_rec_nlb := nm3load.get_nlb(p_nlb_batch_no => pi_batch_no);
--
  l_batch_no := nm3seq.next_rtg_job_id_seq;
--
  INSERT INTO nm_load_batches(nlb_batch_no
                             ,nlb_nlf_id
                             ,nlb_filename
                             ,nlb_record_count)
  VALUES (  l_batch_no
           ,l_rec_nlf.nlf_id
           ,l_rec_nlb.nlb_filename
           ,l_rec_nlb.nlb_record_count); 

--

  DECLARE
    l_tab_batch_no   nm3type.tab_number;
    l_tab_record_no  nm3type.tab_number;
    l_tab_status     nm3type.tab_varchar32767;
    l_tab_text       nm3type.tab_varchar32767;
    l_input_line     nm3type.tab_varchar32767;
  BEGIN
    SELECT l_batch_no a
         , nlbs_record_no
         , nlbs_status
         , nlbs_text
         , nlbs_input_line
       BULK COLLECT INTO l_tab_batch_no
                       , l_tab_record_no
                       , l_tab_status
                       , l_tab_text
                       , l_input_line
      FROM nm_load_batch_status
     WHERE nlbs_nlb_batch_no = pi_batch_no;
   --
    FORALL i IN l_tab_batch_no.FIRST..l_tab_batch_no.LAST
      INSERT INTO nm_load_batch_status 
              (nlbs_nlb_batch_no
              ,nlbs_record_no
              ,nlbs_status
              ,nlbs_text
             ,nlbs_input_line
             )
     VALUES ( l_tab_batch_no(i)
           , l_tab_record_no(i)
           , l_tab_status(i)
           , l_tab_text(i)
           , l_input_line(i) );
  --
  END;

--

  l_sql_2 := 'BEGIN '||
           '  INSERT INTO '||l_new_holding_table||
           '  ( ';
  l_sql_2 := l_sql_2 ||get_tab_cols(l_new_holding_table);
  l_sql_2 := substr(l_sql_2,0,length(l_sql_2)-2);
  l_sql_2 := l_sql_2||'  ) ';
  l_sql_2 := l_sql_2||'SELECT '||l_batch_no||', ';
  l_sql_2 := l_sql_2 ||get_tab_select_cols(l_holding_table,'a');
  l_sql_2 := substr(l_sql_2,0,length(l_sql_2)-1);
  l_sql_2 := l_sql_2||' b.'||get_lat_long (l_rec_nlf.nlf_id, 'IIT_X')
          ||', b.'||get_lat_long (l_rec_nlf.nlf_id, 'IIT_Y');
  --l_sql_2 := l_sql_2||'  b.longitude, b.latitude ';
  l_sql_2 := l_sql_2||'  FROM '||l_holding_table||' a, '||l_holding_table||' b';
  l_sql_2 := l_sql_2||' WHERE a.'||pi_join_column||' = b.'||pi_join_column;
  l_sql_2 := l_sql_2||'   AND a.'||pi_locate_ref_column||' = ''S''';
  l_sql_2 := l_sql_2||'   AND b.'||pi_locate_ref_column||' = ''E''';
  l_sql_2 := l_sql_2||'   AND a.batch_no = '||pi_batch_no;
  l_sql_2 := l_sql_2||'   AND b.batch_no = '||pi_batch_no||';';
  l_sql_2 := l_sql_2||'END;';

--
  nm_debug.debug(l_sql_2);

--
  EXECUTE IMMEDIATE l_sql_2;
--
  po_nlf_id := l_rec_nlf.nlf_id;
  po_nlb_batch_no := l_batch_no;
--
END process_line_data;
--
--------------------------------------------------------------------------------
--
--
END Nm3inv_Load;
/
